class HomeController < ApplicationController
  def show
    @speakers = Speaker.all
    @ticket_types = @event.ticket_types.enabled.order :price
  end
end
