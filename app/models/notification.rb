class Notification < ApplicationRecord
  belongs_to :event

  validates :message, presence: true

  class << self
    def activate(notification)
      transaction do
        deactivate notification.event
        notification.update! active: true
      end
    end

    def deactivate(event) = event.notifications.update_all active: false
    def active_for(event) = event.notifications.find_by active: true
  end
end
