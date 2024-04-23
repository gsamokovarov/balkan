class HomeController < ApplicationController
  def show
    @ticket_types = Current.event.ticket_types.enabled.order :price
  end
end
