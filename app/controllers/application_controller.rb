class ApplicationController < ActionController::Base
  before_action :set_current

  private

  def set_current
    selection_criteria = Rails.env.local? ? { name: Settings.development_event }.compact : { host: request.host }

    Current.host = request.host
    Current.event =
      Event.with_attached_hero_images.includes(:ticket_types, blog_posts: :author).where(selection_criteria).last!
  end
end
