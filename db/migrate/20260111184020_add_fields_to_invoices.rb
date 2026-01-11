class AddFieldsToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :issue_date, :date
    add_column :invoices, :tax_event_date, :date
    add_reference :invoices, :refunded_invoice, foreign_key: { to_table: :invoices }
    add_column :invoices, :receiver_email, :string
    add_column :invoices, :receiver_company_name, :string
    add_column :invoices, :receiver_company_uid, :string
    add_column :invoices, :includes_vat, :boolean, default: true, null: false
    add_column :invoices, :notes, :text
  end
end
