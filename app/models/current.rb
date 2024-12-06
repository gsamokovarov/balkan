class Current < ActiveSupport::CurrentAttributes
  attribute :event, :host

  def show_banner? = event.banitsa?(2024)
end
