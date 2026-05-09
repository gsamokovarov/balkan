require "rails_helper"

RSpec.case Admin::UsersController, type: :request do
  test "organizer sees the activation link on a pending user's show page" do
    create :event, :balkan2025
    sign_in create(:user, :organizer)
    pending_user = User.create! name: "Jane", email: "jane@example.com", role: :organizer

    get admin_user_path(pending_user)

    assert_have_http_status response, :ok
    assert_eq response.body.include?("Activation link"), true
    assert_eq response.body.include?(admin_invitation_url(pending_user.generate_token_for(:invitation))[/\/admin\/invitations\//]), true
  end

  test "staff does not see the activation link on a pending user's show page" do
    create :event, :balkan2025
    sign_in create(:user, :staff)
    pending_user = User.create! name: "Jane", email: "jane@example.com", role: :organizer

    get admin_user_path(pending_user)

    assert_have_http_status response, :ok
    assert_eq response.body.include?("Activation link"), false
    assert_eq response.body.include?("/admin/invitations/"), false
  end
end
