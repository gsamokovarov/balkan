class LineupMember < ApplicationRecord
  belongs_to :event
  belongs_to :speaker
  belongs_to :talk, optional: true

  enum :status, [:pending, :cancelled, :confirmed]
end
