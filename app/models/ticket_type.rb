class TicketType < ApplicationRecord
  belongs_to :event

  scope :enabled, -> { where(enabled: true) }

  def supporter? = name == "Supporter"
end
