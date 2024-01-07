require "rails_helper"

RSpec.case Admin::User do
  around do |test|
    credentials = Admin::User.credentials
    test.run
  ensure
    Admin::User.credentials = credentials
  end

  test "requires credentials for authentication" do
    Admin::User.credentials = nil

    user = Admin::User.new

    assert_raises Precondition::Error do
      user.authenticate
    end
  end

  test "refuses authentication for bad credentials" do
    Admin::User.setup_credentials username: "admin", password: "admin"

    user = Admin::User.new username: "foo", password: "bar"

    assert_eq user.authenticate, false
    assert_eq user.errors[:base], ["Invalid username or password"]
  end

  test "allows authentication for proper credentials" do
    Admin::User.setup_credentials username: "admin", password: "admin"

    user = Admin::User.new username: "admin", password: "admin"

    assert_eq user.authenticate, true
    assert_eq user.errors.none?, true
  end
end
