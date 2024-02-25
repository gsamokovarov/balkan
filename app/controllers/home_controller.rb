class HomeController < ApplicationController
  def show
    @ticket_types = @event.ticket_types.enabled.order :price
  end
end
