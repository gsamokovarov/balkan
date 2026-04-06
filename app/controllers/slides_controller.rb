class SlidesController < ApplicationController
  layout "slides"

  def show
    @slideshow = Current.event.slideshow
  end
end
