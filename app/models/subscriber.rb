class Subscriber < ApplicationRecord
  belongs_to :event

  validates :email, presence: true, uniqueness: true

  generates_token_for :cancelation

  class << self
    def for(event) = where(event:)

    def including_ticket_holders(event)
      ticket_emails = event.tickets.select :email
      tickets_query = event.tickets.select "NULL as id, tickets.email"

      Subscriber.find_by_sql [<<-SQL, { event_id: event.id, tickets_query:, ticket_emails: }]
      SELECT subscribers.id, subscribers.email
        FROM subscribers
       WHERE subscribers.event_id = :event_id
         AND subscribers.email NOT IN (:ticket_emails)

      UNION ALL

      :tickets_query
      SQL
    end
  end

  def cancel_url = Link.subscriber_url generate_token_for(:cancelation)
end
