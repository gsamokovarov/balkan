require "rails_helper"

RSpec.case SponsorshipProspectus do
  test "unlimited variants are shown as unlimited" do
    event = create :event, :balkan2025
    package = create(:sponsorship_package, name: "Test Package", event:)
    create :sponsorship_variant, name: "Gold", price: 5000,
                                 perks: "Logo on website\nBanner at venue",
                                 package:, quantity: nil

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Gold", "€ 5000", "Unlimited"
  end

  test "limited variants show correct number of available spots" do
    event = create :event, :balkan2025
    package = create(:sponsorship_package, name: "Test Package", event:)
    create :sponsorship_variant, name: "Silver", price: 3000,
                                 perks: "Logo on website",
                                 package:, quantity: 3

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Silver", "€ 3000", "3 available"
  end

  test "partially taken variants show correct number of remaining spots" do
    event = create :event, :balkan2025
    package = create(:sponsorship_package, name: "Test Package", event:)
    variant = create :sponsorship_variant, name: "Bronze", price: 1000,
                                           perks: "Logo on website",
                                           package:, quantity: 5
    create :sponsorship, sponsor: create(:sponsor), variant:, event:, price_paid: 1000
    create :sponsorship, sponsor: create(:sponsor), variant:, event:, price_paid: 1000

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Bronze", "€ 1000", "3 available"
  end

  test "sold out variants are marked as sold out" do
    event = create :event, :balkan2025
    package = create(:sponsorship_package, name: "Test Package", event:)
    variant = create :sponsorship_variant, name: "Party", price: 2000,
                                           perks: "Logo at party",
                                           package:, quantity: 1
    create :sponsorship, sponsor: create(:sponsor), variant:, event:, price_paid: 2000

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Party", "€ 2000", "Sold out"
  end

  test "multiple packages show correct availability for each variant" do
    event = create :event, :balkan2025
    package1 = create(:sponsorship_package, name: "Main Packages", event:)
    package2 = create(:sponsorship_package, name: "Add-ons", event:)
    create :sponsorship_variant, name: "Platinum", price: 10_000,
                                 perks: "Everything", package: package1, quantity: 1
    silver = create :sponsorship_variant, name: "Silver", price: 3000,
                                          perks: "Some things", package: package1, quantity: 2
    create :sponsorship, sponsor: create(:sponsor), variant: silver, event:, price_paid: 3000
    create :sponsorship_variant, name: "After-party", price: 5000,
                                 perks: "Host after-party", package: package2, quantity: 1

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Main Packages",
                       "Platinum", "€ 10000", "1 available",
                       "Silver", "€ 3000", "1 available",
                       "Add-ons",
                       "After-party", "€ 5000", "1 available"
  end

  test "prospectus includes venue information when available" do
    venue = create :venue, name: "Test Venue", address: "123 Test Street"
    event = create(:event, :balkan2025, venue:)

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Test Venue, 123 Test Street"
  end

  test "package descriptions are included in the prospectus" do
    event = create :event, :balkan2025
    create(:sponsorship_package,
           name: "Package with Description",
           description: "This is a detailed description of the package.",
           event:)

    pdf = SponsorshipProspectus.generate event

    assert_pdf_content pdf, "Package with Description",
                       "This is a detailed description of the package"
  end
end
