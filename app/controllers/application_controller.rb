class ApplicationController < ActionController::Base
  before_action :set_current

  private

  def set_current
    Current.event = Event.includes(:ticket_types).find_by! name: "Balkan Ruby 2025"
  end
end
