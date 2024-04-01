require "rails_helper"

RSpec.case "Admin", type: :feature do
  around do |test|
    credentials = Admin::User.credentials
    test.run
  ensure
    Admin::User.credentials = credentials
  end

  test "requires authentication" do
    create :event, :balkan2024

    visit admin_root_path

    assert_eq current_path, admin_login_path
  end

  test "shows the admin dashboard after successful authentication" do
    Admin::User.setup_credentials username: "admin", password: "admin"
    create :event, :balkan2024

    visit admin_root_path

    fill_in "Username", with: "admin"
    fill_in "Password", with: "admin"

    click_button "Sign in"

    assert_have_content page, "Health"
    assert_have_content page, "Orders"
    assert_eq current_path, admin_root_path
  end
end
