module VenueDirections
  extend self

  IMAGE_PLACEHOLDER = /\[(\d+)\]/

  def render_directions_markup(venue)
    directions =
      venue.directions.gsub IMAGE_PLACEHOLDER do
        "![photo #{it[1]}](#{image_url venue.additional_images, it[1]})"
      end

    Markup.render_html directions
  end

  private

  def image_url(images, index) = Link.url_for images[index.to_i - 1]
end
