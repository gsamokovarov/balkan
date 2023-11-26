class TicketType < ApplicationFrozenRecord
  def self.current
    ticket_types = TicketType.where(enabled: true)
    precondition ticket_types.count == 1, "One ticket type should be enabled at a time"

    ticket_types.first
  end
end
