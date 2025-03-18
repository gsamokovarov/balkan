class Notification < ApplicationRecord
  belongs_to :event

  validates :message, presence: true

  class << self
    def activate(notification) = transaction { deactivate.then { notification.update! active: true } }
    def deactivate = update_all active: false
    def active = find_by active: true
  end
end
