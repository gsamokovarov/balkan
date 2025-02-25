module ApplicationHelper
  class SectionHighlighter
    def initialize(initial) = @highlighted = initial
    def ! = @highlighted = !@highlighted
  end

  CARD_ROTATIONS = [
    "-rotate-6",
    "-rotate-1",
    "rotate-6 md:rotate-12",
    "rotate-3",
    "-rotate-6 md:-rotate-12",
    "rotate-0",
    "rotate-6",
    "rotate-1",
    "-rotate-3",
  ].freeze

  def card_rotation(index) = CARD_ROTATIONS[index % CARD_ROTATIONS.size]
  def format_money(amount, currency: "€", precision: 2) = number_to_currency(amount, unit: currency, precision:)
  def title(name) = name.presence && content_for(:title) { name }
  def section_highlighter(initial: true) = SectionHighlighter.new initial

  def try_variant(attachment, **)
    attachment.variant(**)
  rescue ActiveStorage::InvariableError
    attachment
  end
end
