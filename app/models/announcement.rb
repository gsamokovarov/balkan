class Announcement < ApplicationRecord
  belongs_to :event

  validates :message, presence: true

  class << self
    def activate(announcement)
      transaction do
        deactivate announcement.event
        announcement.update! active: true
      end
    end

    def deactivate(event) = event.announcements.update_all active: false
    def active_for(event) = event.announcements.find_by active: true
  end
end
