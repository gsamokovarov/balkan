require "openssl"
require "json"
require "zip"

class WalletPass
  IMAGES = %w[icon.png icon@2x.png logo.png logo@2x.png].freeze
  IMAGES_DIR = Rails.root.join "private/wallet_pass"

  def initialize(ticket)
    @ticket = ticket
    @event = ticket.event
  end

  def to_pkpass
    buffer = Zip::OutputStream.write_buffer do |zip|
      files = {}

      pass = pass_json.to_json
      files["pass.json"] = pass
      zip.put_next_entry "pass.json"
      zip.write pass

      IMAGES.each do |image_name|
        path = IMAGES_DIR.join image_name
        next unless path.exist?

        data = path.binread
        files[image_name] = data
        zip.put_next_entry image_name
        zip.write data
      end

      manifest = manifest_json files
      files["manifest.json"] = manifest
      zip.put_next_entry "manifest.json"
      zip.write manifest

      sig = signature manifest
      zip.put_next_entry "signature"
      zip.write sig
    end

    buffer.string
  end

  def content_type = "application/vnd.apple.pkpass"
  def filename = "balkanruby-#{@ticket.id}.pkpass"

  private

  def pass_json
    {
      formatVersion: 1,
      passTypeIdentifier: Settings.apple_wallet_pass_type_identifier,
      teamIdentifier: Settings.apple_wallet_team_identifier,
      serialNumber: @ticket.id.to_s,
      organizationName: "Balkan Ruby",
      description: "Balkan Ruby Conference Ticket",
      foregroundColor: "rgb(255, 255, 255)",
      backgroundColor: "rgb(182, 70, 69)",
      labelColor: "rgb(255, 255, 255)",
      relevantDate: @event.start_date.iso8601,
      eventTicket: {
        headerFields: [
          { key: "ticket_type", label: "TICKET", value: @ticket.ticket_type.name },
        ],
        primaryFields: [
          { key: "event_name", label: "EVENT", value: @event.name },
        ],
        secondaryFields: [
          { key: "dates", label: "DATES", value: format_dates },
          venue_field,
        ].compact,
        auxiliaryFields: [
          { key: "attendee", label: "ATTENDEE", value: @ticket.name },
        ],
        backFields: [
          { key: "email", label: "Email", value: @ticket.email },
          { key: "shirt_size", label: "T-Shirt Size", value: @ticket.shirt_size },
          venue_address_field,
        ].compact,
      },
      barcodes: [
        { message: @ticket.event_access_url, format: "PKBarcodeFormatQR", messageEncoding: "iso-8859-1" },
      ],
      barcode: { message: @ticket.event_access_url, format: "PKBarcodeFormatQR", messageEncoding: "iso-8859-1" },
    }
  end

  def format_dates
    if @event.start_date.month == @event.end_date.month
      "#{@event.start_date.strftime '%b %d'}–#{@event.end_date.strftime '%d, %Y'}"
    else
      "#{@event.start_date.strftime '%b %d'}–#{@event.end_date.strftime '%b %d, %Y'}"
    end
  end

  def venue_field
    return unless @event.venue

    { key: "venue", label: "VENUE", value: @event.venue.name }
  end

  def venue_address_field
    return unless @event.venue&.address

    { key: "venue_address", label: "Venue Address", value: @event.venue.address }
  end

  def manifest_json(files)
    manifest = files.each_with_object({}) do |(name, data), hash|
      hash[name] = Digest::SHA256.hexdigest data
    end

    manifest.to_json
  end

  def signature(manifest_data)
    certificate = OpenSSL::X509::Certificate.new File.read(Settings.apple_wallet_certificate_path)
    private_key = OpenSSL::PKey.read File.read(Settings.apple_wallet_key_path), Settings.apple_wallet_key_password.to_s
    wwdr_cert = OpenSSL::X509::Certificate.new File.read(Settings.apple_wallet_wwdr_path)

    flag = OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::DETACHED
    OpenSSL::PKCS7.sign(certificate, private_key, manifest_data, [wwdr_cert], flag).to_der
  end
end
