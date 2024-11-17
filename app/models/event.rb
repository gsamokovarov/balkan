class Event < ApplicationRecord
  belongs_to :invoice_sequence
  has_many :orders
  has_many :ticket_types, -> { order :price }
  has_many :tickets, through: :orders
  has_many :subscribers

  def static_speakers = StaticSpeaker.where(event_id: id)
  def speakers = StaticTalk.where(event_id: id).select(&:available).flat_map(&:speakers)
  def sponsors = Sponsor.all
  def community_partners = CommunityPartner.all
  def schedule = Schedule.find_by!(event_id: id)
  def blog_posts = BlogPost.where(event_id: id).order(id: :desc)

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
  def beginning_countdown = FinalCountdown.until start_date

  def upcoming? = Date.current.before? start_date
  def single_day? = start_date == end_date

  def balkan? = name.include? "Balkan"
  def banitsa? = name.include? "Banitsa"

  def contact_email = balkan? ? "hi@balkanruby.com" : "hi@rubybanitsa.com"
end
