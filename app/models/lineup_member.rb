class LineupMember < ActiveRecord::Base
  belongs_to :event
  belongs_to :speaker
  belongs_to :talk, optional: true

  enum :status, [:pending, :cancelled, :confirmed]

  def self.for(event) = where(event:)
end
