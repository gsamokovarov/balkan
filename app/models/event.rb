class Event < ApplicationRecord
  belongs_to :invoice_sequence
  has_one :schedule
  has_many :orders
  has_many :ticket_types, -> { order :price }
  has_many :tickets, through: :orders
  has_many :subscribers
  has_many :lineup_members
  has_many :community_partners
  has_many :embeddings
  has_many :sponsorship_packages

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def sponsors = StaticSponsor.all
  def blog_posts = BlogPost.where(event_id: id).order(id: :desc)

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
  def beginning_countdown = FinalCountdown.until start_date

  def upcoming? = Date.current.before? start_date

  def balkan?(year = nil) = name.match? "Balkan.*#{year}"
  def banitsa?(year = nil) = name.match? "Banitsa.*#{year}"

  def contact_email = balkan? ? "hi@balkanruby.com" : "hi@rubybanitsa.com"
end
