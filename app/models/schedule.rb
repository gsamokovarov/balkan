class Schedule < ApplicationRecord
  belongs_to :event
  has_many :slots, -> { order(:date, :time) }, class_name: "ScheduleSlot"

  def slots_for(date) = slots.select { _1.date == date }
end
