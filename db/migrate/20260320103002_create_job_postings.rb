class CreateJobPostings < ActiveRecord::Migration[8.0]
  def change
    create_table :job_postings do |t|
      t.references :event, null: false, foreign_key: true
      t.references :sponsor, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :application_url, null: false
      t.datetime :published_at

      t.timestamps

      t.index [:event_id, :sponsor_id]
    end
  end
end
