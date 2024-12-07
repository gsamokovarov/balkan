class Current < ActiveSupport::CurrentAttributes
  attribute :event, :host

  def show_banner? = false
end
