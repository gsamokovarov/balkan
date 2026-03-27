class MakeApplicationUrlOptionalAndCreateJobPostingContacts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :job_postings, :application_url, true

    create_table :job_posting_contacts do |t|
      t.references :job_posting, null: false, foreign_key: true
      t.string :name
      t.string :email, null: false

      t.timestamps
    end
  end
end
