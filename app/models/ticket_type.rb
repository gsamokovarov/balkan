class TicketType < ApplicationFrozenRecord
  def self.current
    ticket_types = TicketType.where(enabled: true).to_a

    raise "One ticket type should be enabled at a time!" if ticket_types.size != 1

    ticket_types.first
  end
end
