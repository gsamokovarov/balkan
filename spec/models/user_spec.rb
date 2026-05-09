require "rails_helper"

RSpec.case User do
  test "is valid on create without a password (invited user)" do
    user = build :user, password: nil

    assert_eq user.valid?, true
  end

  test "is invalid on update without a password" do
    user = create :user, password: nil

    assert_eq user.valid?(:update), false
    assert_eq user.errors[:password], ["can't be blank"]
  end

  test "is invalid on update when only a blank password is submitted" do
    user = create :user, password: nil

    assert_eq user.update(password: ""), false
    assert_eq user.errors[:password], ["can't be blank"]
    assert_eq user.reload.password_digest, nil
  end

  test "stays valid on update for a user that already has a password" do
    user = create :user, password: "secretsecret"

    assert_eq user.update(name: "Jane Doe"), true
  end

  test "accepts an update that sets a valid password" do
    user = create :user, password: nil

    assert_eq user.update(password: "secretsecret", password_confirmation: "secretsecret"), true
    assert_eq user.reload.authenticate("secretsecret").present?, true
  end

  test "rejects an update with a too-short password" do
    user = create :user, password: nil

    assert_eq user.update(password: "short", password_confirmation: "short"), false
    assert_eq user.errors[:password], ["is too short (minimum is 8 characters)"]
  end

  test "rejects an update with mismatched password confirmation" do
    user = create :user, password: nil

    assert_eq user.update(password: "secretsecret", password_confirmation: "different1234"), false
    assert_eq user.errors[:password_confirmation], ["doesn't match Password"]
  end
end
