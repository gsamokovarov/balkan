class HomeController < ApplicationController
  def show
    @speakers = Speaker.all
    @ticket_types = TicketType.all
  end
end
