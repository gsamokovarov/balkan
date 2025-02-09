require "rails_helper"

RSpec.case "Admin", type: :feature do
  test "requires authentication" do
    create :event, :balkan2025

    visit admin_root_path

    assert_eq current_path, admin_login_path
  end

  test "shows the admin dashboard after successful authentication" do
    create :user, name: "Admin", email: "admin@example.com", password: "admin"
    create :event, :balkan2025

    visit admin_orders_path

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "admin"

    click_button "Sign in"

    assert_have_content page, "Orders"
    assert_eq current_path, admin_orders_path
  end
end
