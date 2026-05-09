require "rails_helper"

RSpec.case "Admin invitation", type: :feature do
  test "an admin invites a new user, who activates their account by setting a password" do
    create :event, :balkan2025
    sign_in_admin

    visit new_admin_user_path

    fill_in "Name", with: "Jane Invitee"
    fill_in "Email", with: "jane@example.com"
    click_button "Save"

    assert_have_content page, "User was created"
    assert_have_content page, "Activation link"
    assert_have_content page, "This user hasn't set a password yet"

    activation_url = find("code[data-clipboard-target='source']").text
    activation_path = URI.parse(activation_url).request_uri

    Capybara.reset_sessions!

    visit activation_path

    assert_have_content page, "Set your password"
    assert_have_content page, "Welcome Jane Invitee"

    fill_in "Password", with: "secretsecret"
    fill_in "Password confirmation", with: "secretsecret"
    click_button "Set password"

    assert_have_content page, "Welcome!"
    assert_eq current_path, admin_root_path

    invitee = User.find_by! email: "jane@example.com"
    assert_eq invitee.authenticate("secretsecret").present?, true
    assert_eq invitee.sessions.any?, true
  end

  test "the activation link stops working once the password is set" do
    create :event, :balkan2025
    sign_in_admin

    visit new_admin_user_path
    fill_in "Name", with: "Jane Invitee"
    fill_in "Email", with: "jane@example.com"
    click_button "Save"

    activation_url = find("code[data-clipboard-target='source']").text
    activation_path = URI.parse(activation_url).request_uri

    Capybara.reset_sessions!

    visit activation_path
    fill_in "Password", with: "secretsecret"
    fill_in "Password confirmation", with: "secretsecret"
    click_button "Set password"

    Capybara.reset_sessions!

    visit activation_path

    assert_have_content page, "Invitation link is invalid or expired"
    assert_eq current_path, admin_login_path
  end

  def sign_in_admin
    create :user, name: "Admin", email: "admin@example.com", password: "test1234"

    visit admin_login_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "test1234"
    click_button "Sign in"
  end
end
