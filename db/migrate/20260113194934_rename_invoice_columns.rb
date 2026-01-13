class RenameInvoiceColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :invoices, :receiver_company_uid, :receiver_company_idx
    rename_column :invoices, :customer_vat_id, :customer_vat_idx
  end
end
