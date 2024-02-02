class Event < ApplicationRecord
  has_many :ticket_types
  has_many :orders
  has_many :tickets, through: :orders
  has_many :subscribers

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
end
