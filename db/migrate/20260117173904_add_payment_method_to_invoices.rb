class AddPaymentMethodToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :payment_method, :string
  end
end
