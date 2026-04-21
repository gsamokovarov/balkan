require "zip"

module WalletPass
  extend self

  def to_pkpass(ticket)
    files = {
      "pass.json" => pass_definition(ticket).to_json,
      "icon.png" => Rails.public_path.join("pass/icon.png").binread,
      "icon@2x.png" => Rails.public_path.join("pass/icon@2x.png").binread,
      "logo.png" => Rails.public_path.join("pass/logo.png").binread,
      "logo@2x.png" => Rails.public_path.join("pass/logo@2x.png").binread,
    }

    files["manifest.json"] = files.transform_values { Digest::SHA256.hexdigest it }.to_json
    files["signature"] = sign files["manifest.json"]

    Zip::OutputStream.write_buffer do |zip|
      files.each do |name, data|
        zip.put_next_entry name
        zip.write data
      end
    end.string
  end

  private

  def pass_definition(ticket)
    event = ticket.event
    date_format =
      if event.start_date == event.end_date
        event.start_date.strftime "%b %d, %Y"
      else
        "#{event.start_date.strftime '%b %d'}–#{event.end_date.strftime '%d, %Y'}"
      end

    {
      formatVersion: 1,
      passTypeIdentifier: Settings.apple_wallet_pass_type_identifier,
      teamIdentifier: Settings.apple_wallet_team_identifier,
      serialNumber: ticket.id.to_s,
      organizationName: event.name,
      description: "#{event.name} ticket",
      foregroundColor: "rgb(255, 255, 255)",
      backgroundColor: "rgb(182, 70, 69)",
      labelColor: "rgb(255, 255, 255)",
      relevantDates: (event.start_date..event.end_date).map do
        { startDate: it.change(hour: 9).iso8601, endDate: it.change(hour: 17).iso8601 }
      end,
      eventTicket: {
        headerFields: [
          { key: "ticket_type", label: "TICKET", value: ticket.ticket_type.name },
        ],
        primaryFields: [
          { key: "event_name", label: "EVENT", value: event.name },
        ],
        secondaryFields: [
          { key: "dates", label: "DATES", value: date_format },
        ],
        auxiliaryFields: [
          { key: "attendee", label: "ATTENDEE", value: ticket.name },
        ],
        backFields: [
          { key: "email", label: "Email", value: ticket.email },
          { key: "shirt_size", label: "T-Shirt Size", value: ticket.shirt_size },
        ],
      },
      barcodes: [
        { message: ticket.event_access_url, format: "PKBarcodeFormatQR", messageEncoding: "iso-8859-1" },
      ],
    }
  end

  def sign(data)
    @cert ||= OpenSSL::X509::Certificate.new Settings.apple_wallet_certificate
    @key ||= OpenSSL::PKey.read Settings.apple_wallet_key
    @wwdr ||= OpenSSL::X509::Certificate.new Settings.apple_wallet_wwdr

    OpenSSL::PKCS7.sign(@cert, @key, data, [@wwdr], OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::DETACHED).to_der
  end
end
