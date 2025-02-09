class Event < ApplicationRecord
  belongs_to :invoice_sequence
  belongs_to :venue, optional: true
  has_one :schedule
  has_many :orders
  has_many :ticket_types, -> { order :price }
  has_many :tickets, through: :orders
  has_many :subscribers
  has_many :lineup_members
  has_many :community_partners
  has_many :embeddings
  has_many :sponsorship_packages
  has_many :sponsorship_variants, through: :sponsorship_packages, source: :variants
  has_many :sponsorships

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def blog_posts = StaticBlogPost.where(event_id: id).order(id: :desc)

  def sponsors = sponsorships.includes(:package, :sponsor).order("sponsorship_packages.id").group_by(&:package)

  def speaker_applications_countdown = FinalCountdown.until speaker_applications_end_date
  def beginning_countdown = FinalCountdown.until start_date

  def upcoming? = Date.current.before? start_date

  def balkan?(year = nil) = name.match? "Balkan.*#{year}"
  def banitsa?(year = nil) = name.match? "Banitsa.*#{year}"

  def contact_email = balkan? ? "hi@balkanruby.com" : "hi@rubybanitsa.com"
end
