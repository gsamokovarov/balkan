require "rails_helper"

RSpec.case WalletPass, type: :model do
  test "generates a valid pkpass ZIP" do
    event = create :event, :balkan2025
    order = create(:order, event:)
    ticket_type = create(:ticket_type, :enabled, event:)
    ticket = create :ticket, :early_bird, ticket_type:, order:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    data = WalletPass.to_pkpass ticket

    entries = {}
    Zip::InputStream.open StringIO.new(data) do |zip|
      while (entry = zip.get_next_entry)
        entries[entry.name] = zip.read
      end
    end

    assert_eq entries.keys.sort, ["icon.png", "icon@2x.png", "logo.png", "logo@2x.png", "manifest.json", "pass.json", "signature"]

    assert_eq JSON.parse(entries["pass.json"]), {
      "formatVersion" => 1,
      "passTypeIdentifier" => Settings.apple_wallet_pass_type_identifier,
      "teamIdentifier" => Settings.apple_wallet_team_identifier,
      "serialNumber" => ticket.id.to_s,
      "organizationName" => event.name,
      "description" => "#{event.name} ticket",
      "foregroundColor" => "rgb(255, 255, 255)",
      "backgroundColor" => "rgb(182, 70, 69)",
      "labelColor" => "rgb(255, 255, 255)",
      "relevantDates" => (event.start_date..event.end_date).map do |date|
        { "startDate" => date.change(hour: 9).iso8601, "endDate" => date.change(hour: 17).iso8601 }
      end,
      "eventTicket" => {
        "headerFields" => [
          { "key" => "ticket_type", "label" => "TICKET", "value" => "Early Bird" },
        ],
        "primaryFields" => [
          { "key" => "event_name", "label" => "EVENT", "value" => "Balkan Ruby 2025" },
        ],
        "secondaryFields" => [
          { "key" => "dates", "label" => "DATES", "value" => "Apr 24–25, 2025" },
        ],
        "auxiliaryFields" => [
          { "key" => "attendee", "label" => "ATTENDEE", "value" => "Genadi Samokovarov" },
        ],
        "backFields" => [
          { "key" => "email", "label" => "Email", "value" => "genadi@hey.com" },
          { "key" => "shirt_size", "label" => "T-Shirt Size", "value" => "M" },
        ],
      },
      "barcodes" => [
        { "message" => ticket.event_access_url, "format" => "PKBarcodeFormatQR", "messageEncoding" => "iso-8859-1" },
      ],
    }

    assert_eq JSON.parse(entries["manifest.json"]).keys.sort, ["icon.png", "icon@2x.png", "logo.png", "logo@2x.png", "pass.json"]
  end
end
