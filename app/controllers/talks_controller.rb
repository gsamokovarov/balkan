class TalksController < ApplicationController
  def show
    @talk = StaticTalk.find params[:id].to_i
  end

  def thumbnail
    @talk = StaticTalk.find params[:id].to_i
  end
end
