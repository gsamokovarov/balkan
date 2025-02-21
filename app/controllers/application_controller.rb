class ApplicationController < ActionController::Base
  before_action :set_current

  private

  def set_current
    Current.host = request.host
    Current.event =
      Event.with_attached_hero_images.includes(:ticket_types, blog_posts: :author).find_by!(
        if Rails.env.development?
          { name: Settings.development_event }
        else
          { host: request.host }
        end,
      )
  end
end
