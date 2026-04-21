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

    files["manifest.json"] = files.transform_values { Digest::SHA1.hexdigest it }.to_json
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

    secondary_fields = [
      { key: "dates", label: "DATES", value: date_format },
    ]
    back_fields = [
      { key: "email", label: "Email", value: ticket.email },
    ]

    if event.venue
      secondary_fields << { key: "venue", label: "VENUE", value: event.venue.name }
      back_fields << { key: "address", label: "Address", value: event.venue.address } if event.venue.address.present?
    end

    {
      formatVersion: 1,
      passTypeIdentifier: Settings.apple_wallet_pass_type_identifier,
      teamIdentifier: Settings.apple_wallet_team_identifier,
      serialNumber: ticket.id.to_s,
      organizationName: event.name,
      description: "#{event.name} ticket",
      foregroundColor: "rgb(0, 0, 0)",
      backgroundColor: "rgb(253, 242, 243)",
      labelColor: "rgb(0, 0, 0)",
      relevantDates: (event.start_date..event.end_date).map do
        { startDate: it.in_time_zone.change(hour: 9).iso8601, endDate: it.in_time_zone.change(hour: 17).iso8601 }
      end,
      eventTicket: {
        headerFields: [
          { key: "ticket_type", label: "TICKET", value: ticket.supporter? ? "Supporter" : "Regular" },
        ],
        primaryFields: [
          { key: "event_name", label: "EVENT", value: event.name },
        ],
        secondaryFields: secondary_fields,
        auxiliaryFields: [
          { key: "attendee", label: "ATTENDEE", value: ticket.name },
          { key: "shirt_size", label: "T-SHIRT", value: ticket.shirt_size },
        ],
        backFields: back_fields,
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
