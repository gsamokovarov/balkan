class MakeInvoiceOrderIdNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :invoices, :order_id, true
  end
end
