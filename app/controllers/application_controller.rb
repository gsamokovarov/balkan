class ApplicationController < ActionController::Base
  before_action :set_current

  private

  def set_current
    Current.event = Event.find_by! name: "Balkan Ruby 2024"
  end
end
