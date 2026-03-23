class RemoveDeadlineFieldsFromContracts < ActiveRecord::Migration[8.0]
  def change
    remove_column :contracts, :payment_deadline, :date
    remove_column :contracts, :materials_deadline, :date
  end
end
