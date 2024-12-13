class ScheduleSlot < ApplicationRecord
  belongs_to :schedule

  validates :date, presence: true
  validates :time, presence: true

  def time
    if timestamp = super and date
      timestamp.change year: date.year, day: date.day, month: date.month
    end
  end
end
