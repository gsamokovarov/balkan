# frozen_string_literal: true

module ApplicationHelper
  PRIMARY_BUTTON_CLASSES = %w[
    inline-flex
    justify-center
    items-center
    gap-2
    font-semibold
    border-2
    border-black
    rounded
    py-3
    px-8
    bg-black
    hover:bg-brand-600
    text-white
    hover:shadow-brutal
    hover:-translate-x-1
    hover:-translate-y-1
    transition
    ease-in-out
  ].freeze

  SECONDARY_BUTTON_CLASSES = %w[
    inline-flex
    justify-center
    items-center
    gap-2
    border-2
    border-black
    rounded-full
    py-2
    px-4
    hover:shadow-brutal
    hover:-translate-x-1
    hover:-translate-y-1
    transition
    ease-in-out
  ].freeze

  def primary_button(url, **options, &block)
    defaults = {class: PRIMARY_BUTTON_CLASSES}

    link_to url, defaults.merge(options), &block
  end

  def secondary_button(url, **options, &block)
    defaults = {class: SECONDARY_BUTTON_CLASSES}

    link_to url, defaults.merge(options), &block
  end

  def social_link(url, **options, &block)
    defaults = {target: "_blank", class: "text-brand-50 hover:text-brand-300"}
    link_to url, defaults.merge(options), &block
  end
end
