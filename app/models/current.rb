class Current < ActiveSupport::CurrentAttributes
  attribute :event, :host, :session

  def user = session&.user
end
