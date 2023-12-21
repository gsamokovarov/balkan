class Subscriber < ApplicationRecord
  belongs_to :event

  validates :email, presence: true, uniqueness: true

  generates_token_for :cancelation

  def cancel_url
    Link.subscriber_url generate_token_for(:cancelation)
  end
end
