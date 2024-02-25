class TalksController < ApplicationController
  def show
    @talk = Talk.find params[:id].to_i
  end
end
