class Event < ApplicationRecord
  has_many :orders
  has_many :ticket_types
  has_many :tickets, through: :orders
  has_many :subscribers
  has_one :invoice_sequence

  def speakers = Talk.all.flat_map(&:speakers)
  def sponsors = Sponsor.all
  def community_partners = CommunityPartner.all

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
  def beginning_countdown = FinalCountdown.until start_date
end
