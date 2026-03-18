require "rails_helper"

RSpec.case WalletPass, type: :model do
  test "generates a valid pkpass ZIP" do
    venue = create :venue, name: "International Expo Center", address: "147 Tsarigradsko Shose, Sofia"
    event = create(:event, :balkan2025, venue:)
    order = create(:order, event:)
    ticket_type = create(:ticket_type, :enabled, event:)
    ticket = create :ticket, :early_bird, ticket_type:, order:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    pass = WalletPass.new ticket

    # Stub signing to avoid needing real certificates
    allow(pass).to receive(:signature).and_return("fake-signature")

    data = pass.to_pkpass

    entries = {}
    Zip::InputStream.open StringIO.new(data) do |zip|
      while (entry = zip.get_next_entry)
        entries[entry.name] = zip.read
      end
    end

    assert_eq entries.key?("pass.json"), true
    assert_eq entries.key?("manifest.json"), true
    assert_eq entries.key?("signature"), true

    barcode = { "message" => ticket.event_access_url, "format" => "PKBarcodeFormatQR", "messageEncoding" => "iso-8859-1" }

    assert_eq JSON.parse(entries["pass.json"]), {
      "formatVersion" => 1,
      "passTypeIdentifier" => Settings.apple_wallet_pass_type_identifier,
      "teamIdentifier" => Settings.apple_wallet_team_identifier,
      "serialNumber" => ticket.id.to_s,
      "organizationName" => "Balkan Ruby",
      "description" => "Balkan Ruby Conference Ticket",
      "foregroundColor" => "rgb(255, 255, 255)",
      "backgroundColor" => "rgb(182, 70, 69)",
      "labelColor" => "rgb(255, 255, 255)",
      "relevantDate" => "2025-04-24",
      "eventTicket" => {
        "headerFields" => [
          { "key" => "ticket_type", "label" => "TICKET", "value" => "Early Bird" },
        ],
        "primaryFields" => [
          { "key" => "event_name", "label" => "EVENT", "value" => "Balkan Ruby 2025" },
        ],
        "secondaryFields" => [
          { "key" => "dates", "label" => "DATES", "value" => "Apr 24–25, 2025" },
          { "key" => "venue", "label" => "VENUE", "value" => "International Expo Center" },
        ],
        "auxiliaryFields" => [
          { "key" => "attendee", "label" => "ATTENDEE", "value" => "Genadi Samokovarov" },
        ],
        "backFields" => [
          { "key" => "email", "label" => "Email", "value" => "genadi@hey.com" },
          { "key" => "shirt_size", "label" => "T-Shirt Size", "value" => "M" },
          { "key" => "venue_address", "label" => "Venue Address", "value" => "147 Tsarigradsko Shose, Sofia" },
        ],
      },
      "barcodes" => [barcode],
      "barcode" => barcode,
    }

    manifest = JSON.parse entries["manifest.json"]
    assert_eq manifest.key?("pass.json"), true
  end

  test "filename includes ticket id" do
    ticket = build :ticket, id: 42
    pass = WalletPass.new ticket

    assert_eq pass.filename, "balkanruby-42.pkpass"
  end

  test "content_type is pkpass" do
    ticket = build :ticket
    pass = WalletPass.new ticket

    assert_eq pass.content_type, "application/vnd.apple.pkpass"
  end
end
