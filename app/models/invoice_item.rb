class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  def description(locale:) = locale.to_sym == :bg ? description_bg : description_en
end
