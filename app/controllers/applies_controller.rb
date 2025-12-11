class AppliesController < ApplicationController
  def show
    if Current.event.accepts_speaking_applications?
      redirect_to Current.event.speaker_applications_url, allow_other_host: true
    else
      redirect_to root_path
    end
  end
end
