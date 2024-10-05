class ApplicationController < ActionController::Base
  before_action :set_current

  private

  def set_current
    Current.event =
      case request.host
      when "conf.rubybanitsa.com"
        Event.includes(:ticket_types).find_by! name: "Ruby Banitsa 2024"
      else
        Event.includes(:ticket_types).find_by! name: "Balkan Ruby 2025"
      end
  end
end
