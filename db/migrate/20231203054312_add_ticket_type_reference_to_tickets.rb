class AddTicketTypeReferenceToTickets < ActiveRecord::Migration[7.1]
  def change
    add_belongs_to :tickets, :ticket_type, foreign_key: true
  end
end
