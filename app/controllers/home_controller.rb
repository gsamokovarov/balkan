class HomeController < ApplicationController
  def show
    @event = Event.find_by! name: "Balkan Ruby 2024"
    @speakers = Speaker.all
    @ticket_types = TicketType.all
  end
end
