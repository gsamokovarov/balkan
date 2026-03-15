require "rails_helper"

RSpec.case WalletPass, type: :model do
  test "generates a valid pkpass ZIP" do
    venue = create :venue
    event = create :event, :balkan2025, venue: venue
    order = create :order, event: event
    ticket_type = create(:ticket_type, :enabled, event:)
    ticket = create :ticket, :early_bird, ticket_type:, order:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    pass = WalletPass.new(ticket)

    # Stub signing to avoid needing real certificates
    allow(pass).to receive(:signature).and_return("fake-signature")

    data = pass.to_pkpass

    entries = {}
    Zip::InputStream.open(StringIO.new(data)) do |zip|
      while (entry = zip.get_next_entry)
        entries[entry.name] = zip.read
      end
    end

    assert_eq entries.key?("pass.json"), true
    assert_eq entries.key?("manifest.json"), true
    assert_eq entries.key?("signature"), true

    pass_json = JSON.parse(entries["pass.json"])
    assert_eq pass_json["formatVersion"], 1
    assert_eq pass_json["organizationName"], "Balkan Ruby"
    assert_eq pass_json["description"], "Balkan Ruby Conference Ticket"
    assert_eq pass_json["serialNumber"], ticket.id.to_s
    assert_eq pass_json["eventTicket"]["primaryFields"][0]["value"], "Balkan Ruby 2025"
    assert_eq pass_json["eventTicket"]["auxiliaryFields"][0]["value"], "Genadi Samokovarov"
    assert_eq pass_json["eventTicket"]["secondaryFields"].any? { |f| f["key"] == "venue" }, true
    assert_eq pass_json["barcodes"][0]["format"], "PKBarcodeFormatQR"

    manifest = JSON.parse(entries["manifest.json"])
    assert_eq manifest.key?("pass.json"), true
  end

  test "filename includes ticket id" do
    ticket = build(:ticket, id: 42)
    pass = WalletPass.new(ticket)

    assert_eq pass.filename, "balkanruby-42.pkpass"
  end

  test "content_type is pkpass" do
    ticket = build(:ticket)
    pass = WalletPass.new(ticket)

    assert_eq pass.content_type, "application/vnd.apple.pkpass"
  end
end
