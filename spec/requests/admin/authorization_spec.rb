require "rails_helper"

RSpec.case "Admin authorization", type: :request do
  test "staff users cannot create through admin controllers" do
    create :event, :balkan2025
    sign_in create(:user, :staff)

    post admin_sponsors_path, params: { sponsor: { name: "Acme", description: "X", url: "https://example.com" } }

    assert_have_http_status response, :redirect
    assert_eq Sponsor.exists?(name: "Acme"), false
  end

  test "staff users cannot update through admin controllers" do
    create :event, :balkan2025
    sign_in create(:user, :staff)
    sponsor = create :sponsor, name: "Original"

    patch admin_sponsor_path(sponsor), params: { sponsor: { name: "Tampered" } }

    assert_have_http_status response, :redirect
    assert_eq sponsor.reload.name, "Original"
  end

  test "staff users can read through admin controllers" do
    create :event, :balkan2025
    sign_in create(:user, :staff)

    get admin_sponsors_path

    assert_have_http_status response, :ok
  end

  test "organizer users can create through admin controllers" do
    create :event, :balkan2025
    sign_in create(:user, :organizer)

    post admin_sponsors_path, params: { sponsor: { name: "Acme", description: "X", url: "https://example.com" } }

    assert_have_http_status response, :redirect
    assert_eq Sponsor.exists?(name: "Acme"), true
  end
end
