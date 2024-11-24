class LineupMember < ActiveRecord::Base
  belongs_to :event
  belongs_to :speaker
  belongs_to :talk, optional: true

  def self.for(event) = where(event:)
end
