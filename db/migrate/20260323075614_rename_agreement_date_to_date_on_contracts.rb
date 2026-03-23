class RenameAgreementDateToDateOnContracts < ActiveRecord::Migration[8.0]
  def change
    rename_column :contracts, :agreement_date, :date
  end
end
