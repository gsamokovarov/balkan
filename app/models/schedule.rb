class Schedule < ApplicationRecord
  belongs_to :event
  has_many :slots, -> { order(:date, :time) }, class_name: "ScheduleSlot"

  accepts_nested_attributes_for :slots, destroy_missing: true

  time_as_boolean :published

  def dates = (event.start_date..event.end_date).to_a
  def slots_for(date) = slots.select { it.date == date }
  def slots_for_day(number) = slots_for dates[number]
end
