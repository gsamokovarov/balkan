class ApplicationController < ActionController::Base
  layout :current_event_layout

  before_action :set_current

  private

  def set_current
    Current.host = request.host
    Current.event =
      if Rails.env.development?
        Event.includes(:ticket_types).find_by! name: Settings.development_event
      else
        Event.includes(:ticket_types).find_by! host: request.host
      end
  end

  def current_event_layout
    if turbo_frame_request?
      "turbo_rails/frame"
    elsif Current.event.banitsa?
      "banitsa"
    else
      "application"
    end
  end
end
