class InfraController < ActionController::Base
  def health
    Event.count
    head :ok
  end

  def version
    render plain: ENV.fetch("GIT_REVISION")
  end
end
