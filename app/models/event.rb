class Event < ApplicationRecord
  has_many :orders
  has_many :ticket_types
  has_many :tickets, through: :orders
  has_many :subscribers
  has_one :invoice_sequence

  def speakers = Talk.all.select(&:available).flat_map(&:speakers)
  def sponsors = Sponsor.all
  def community_partners = CommunityPartner.all
  def schedule = Schedule.find_by!(event_name: name)
  def blog_posts = BlogPost.all.order(id: :desc)

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
  def beginning_countdown = FinalCountdown.until start_date

  def upcoming? = Date.current.before? start_date
end
