class AddCompanyDetailsToSponsors < ActiveRecord::Migration[8.0]
  def change
    add_column :sponsors, :address, :string
    add_column :sponsors, :country, :string
    add_column :sponsors, :company_id_number, :string
    add_column :sponsors, :vat_id, :string
    add_column :sponsors, :representative_name, :string
  end
end
