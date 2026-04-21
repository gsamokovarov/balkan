require "rails_helper"

RSpec.case WalletPass, type: :model do
  test "generates a valid pkpass ZIP" do
    venue = create :venue, name: "Material House", address: "Tsar Samuil 73, Sofia"
    event = create(:event, :balkan2025, venue: venue, contact_email: "hello@balkanruby.com")
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
      "foregroundColor" => "rgb(0, 0, 0)",
      "backgroundColor" => "rgb(253, 242, 243)",
      "labelColor" => "rgb(0, 0, 0)",
      "relevantDates" => (event.start_date..event.end_date).map do |date|
        { "startDate" => date.in_time_zone.change(hour: 9).iso8601, "endDate" => date.in_time_zone.change(hour: 17).iso8601 }
      end,
      "eventTicket" => {
        "headerFields" => [
          { "key" => "ticket_type", "label" => "TICKET", "value" => "Regular" },
        ],
        "primaryFields" => [
          { "key" => "event_name", "label" => "EVENT", "value" => "Balkan Ruby 2025" },
        ],
        "secondaryFields" => [
          { "key" => "dates", "label" => "DATES", "value" => "Apr 24–25, 2025" },
          { "key" => "venue", "label" => "VENUE", "value" => "Material House" },
        ],
        "auxiliaryFields" => [
          { "key" => "attendee", "label" => "ATTENDEE", "value" => "Genadi Samokovarov" },
          { "key" => "shirt_size", "label" => "T-SHIRT", "value" => "M" },
        ],
        "backFields" => [
          { "key" => "email", "label" => "Support email", "value" => "hello@balkanruby.com" },
          { "key" => "address", "label" => "Venue address", "value" => "Tsar Samuil 73, Sofia" },
        ],
      },
      "barcodes" => [
        { "message" => ticket.event_access_url, "format" => "PKBarcodeFormatQR", "messageEncoding" => "iso-8859-1" },
      ],
    }

    assert_eq JSON.parse(entries["manifest.json"]).keys.sort, ["icon.png", "icon@2x.png", "logo.png", "logo@2x.png", "pass.json"]
  end

  test "labels supporter tickets in the top-right badge" do
    event = create :event, :balkan2025
    order = create(:order, event:)
    ticket_type = create(:ticket_type, :enabled, event:, name: "Supporter")
    ticket = create :ticket, :early_bird, ticket_type:, order:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    data = WalletPass.to_pkpass ticket

    pass_json = nil
    Zip::InputStream.open StringIO.new(data) do |zip|
      while (entry = zip.get_next_entry)
        pass_json = zip.read if entry.name == "pass.json"
      end
    end

    assert_eq JSON.parse(pass_json).dig("eventTicket", "headerFields"), [
      { "key" => "ticket_type", "label" => "TICKET", "value" => "Supporter" },
    ]
  end
end
