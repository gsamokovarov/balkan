class Current < ActiveSupport::CurrentAttributes
  attribute :event

  def show_banner? = true
end
