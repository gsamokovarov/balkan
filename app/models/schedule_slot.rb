class ScheduleSlot < ApplicationRecord
  belongs_to :schedule

  validates :date, presence: true
  validates :time, presence: true
end
