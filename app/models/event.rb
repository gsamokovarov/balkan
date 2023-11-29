class Event < ApplicationRecord
  has_many :ticket_types
  has_many :order
  has_many :tickets, through: :orders
end
