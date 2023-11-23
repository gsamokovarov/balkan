# frozen_string_literal: true

module ApplicationHelper
  CARD_ROTATIONS = [
    "-rotate-6",
    "-rotate-1",
    "rotate-6 md:rotate-12",
    "rotate-3",
    "-rotate-6 md:-rotate-12",
    "rotate-0",
    "rotate-6",
    "rotate-1",
    "-rotate-3"
  ]

  def card_rotation(index)
    CARD_ROTATIONS[index % CARD_ROTATIONS.size]
  end

  def format_money(amount, currency: "€", precision: 2)
    number_to_currency(amount, unit: currency, precision: precision)
  end

  def title(name)
    content_for(:title) { "– #{name}" } if name.present?
    nil
  end
end
