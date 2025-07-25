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
  ]

  def card_rotation(index) = CARD_ROTATIONS[index % CARD_ROTATIONS.size]
  def format_money(amount, currency: "€", precision: 2) = number_to_currency(amount, unit: currency, precision:)
  def title(name) = name.presence && content_for(:title) { name }
  def section_highlighter(initial: true) = SectionHighlighter.new initial
  def try_variant(att, **) = att.blob.content_type == "image/svg+xml" ? att : att.variant(**)

  def marketing_form(scope: nil, model: false, url: nil, **options, &)
    html_options = options[:html] || {}

    tag.div class: html_options.delete(:class) do
      options[:html] = { class: ["space-y-10"], **html_options }
      form_with(scope:, model:, url:, builder: FormHelper::Builder, **options, &)
    end
  end
end
