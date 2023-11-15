class TicketsController < ApplicationController
  def index
    @ticket_types = TicketType.all
  end
end
