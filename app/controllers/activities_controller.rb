class ActivitiesController < ApplicationController
  def index
    @activity = Current.event.event_activity
  end
end
