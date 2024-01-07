class Admin::User
  include ActiveModel::Model

  Credentials = Data.define :username, :password

  class << self
    attr_accessor :credentials

    def setup_credentials(username:, password:)
      @credentials = Credentials.new username:, password:
    end
  end

  attr_accessor :username, :password

  validates :username, presence: true
  validates :password, presence: true

  def authenticate
    precondition self.class.credentials, "Setup Admin::User.credentials"

    authenticated =
      valid? &&
      username == self.class.credentials.username &&
      password == self.class.credentials.password

    return true if authenticated

    errors.add :base, "Invalid username or password"

    false
  end
end
