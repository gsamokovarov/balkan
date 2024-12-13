class ScheduleSlot < ApplicationRecord
  belongs_to :schedule
  belongs_to :lineup_member

  validates :date, presence: true
  validates :time, presence: true

  def time
    if timestamp = super and date
      timestamp.change year: date.year, day: date.day, month: date.month
    end
  end
end
