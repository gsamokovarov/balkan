class HomeController < ApplicationController
  def retrospective
    Current.event = Event.find_by! name: "Balkan Ruby 2024"
  end
end
