class ApplicationController < ActionController::Base
  layout :current_event_layout

  before_action :set_current

  private

  def set_current
    Current.host = request.host
    Current.event =
      case request.host
      when "conf.rubybanitsa.com", -> _ { Rails.env.devleopment? }
        Event.includes(:ticket_types).find_by! name: "Ruby Banitsa 2024"
      when "2024.balkanruby.com"
        Event.includes(:ticket_types).find_by! name: "Balkan Ruby 2024"
      else
        Event.includes(:ticket_types).find_by! name: "Balkan Ruby 2025"
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
