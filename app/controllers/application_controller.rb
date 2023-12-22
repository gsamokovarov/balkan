class ApplicationController < ActionController::Base
  before_action :set_current_event

  private

  def set_current_event
    @event = Event.find_by! name: "Balkan Ruby 2024"
  end
end
