# frozen_string_literal: true

module ApplicationHelper
  def social_link(url, **options, &block)
    defaults = {target: "_blank", class: "text-banitsa-50 hover:text-banitsa-300"}
    link_to url, defaults.merge(options), &block
  end
end
