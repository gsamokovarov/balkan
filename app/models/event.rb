class Event < ApplicationRecord
  has_many :ticket_types
  has_many :orders
  has_many :tickets, through: :orders
end
