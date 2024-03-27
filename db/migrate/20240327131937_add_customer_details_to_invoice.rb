class AddCustomerDetailsToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :customer_name, :string
    add_column :invoices, :customer_address, :string
    add_column :invoices, :customer_country, :string
    add_column :invoices, :customer_vat_id, :string
  end
end
