require "rails_helper"

RSpec.case Admin::InvitationsController, type: :request do
  test "show renders the set-password form for a valid token" do
    create :event, :balkan2025
    user = User.create! name: "New Admin", email: "new@example.com", role: :staff
    token = user.generate_token_for :invitation

    get admin_invitation_path(token)

    assert_have_http_status response, :ok
  end

  test "show redirects with an alert when the token is invalid" do
    create :event, :balkan2025

    get admin_invitation_path("nope")

    assert_have_http_status response, :redirect
    assert_eq flash[:alert], "Invitation link is invalid or expired"
  end

  test "update sets the password and starts a session" do
    create :event, :balkan2025
    user = User.create! name: "New Admin", email: "new@example.com", role: :staff
    token = user.generate_token_for :invitation

    patch admin_invitation_path(token), params: {
      user: { password: "secretsecret", password_confirmation: "secretsecret" },
    }

    assert_have_http_status response, :redirect
    assert_eq user.reload.authenticate("secretsecret").present?, true
    assert_eq user.sessions.any?, true
  end

  test "update rerenders when passwords don't match" do
    create :event, :balkan2025
    user = User.create! name: "New Admin", email: "new@example.com", role: :staff
    token = user.generate_token_for :invitation

    patch admin_invitation_path(token), params: {
      user: { password: "secretsecret", password_confirmation: "different1234" },
    }

    assert_have_http_status response, :unprocessable_content
    assert_eq user.reload.password_digest, nil
  end

  test "the same token cannot be reused after the password is set" do
    create :event, :balkan2025
    user = User.create! name: "New Admin", email: "new@example.com", role: :staff
    token = user.generate_token_for :invitation

    patch admin_invitation_path(token), params: {
      user: { password: "secretsecret", password_confirmation: "secretsecret" },
    }
    get admin_invitation_path(token)

    assert_have_http_status response, :redirect
    assert_eq flash[:alert], "Invitation link is invalid or expired"
  end
end
