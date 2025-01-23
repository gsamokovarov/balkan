class Subscriber < ApplicationRecord
  belongs_to :event

  validates :email, presence: true, uniqueness: true

  generates_token_for :cancelation

  def self.including_ticket_holders(*events)
    ticket_emails = Ticket.joins(:order).where(order: { event: events }).select :email
    tickets_query = Ticket.joins(:order).where(order: { event: events }).select "NULL as id, tickets.email"

    Subscriber.find_by_sql [<<-SQL, event_ids: events.pluck(:id), tickets_query:, ticket_emails:]
      SELECT subscribers.id, subscribers.email
        FROM subscribers
       WHERE subscribers.event_id IN (:event_ids)
         AND subscribers.email NOT IN (:ticket_emails)

      UNION

      :tickets_query
    SQL
  end

  def cancel_url = Link.subscriber_url generate_token_for(:cancelation)
end
