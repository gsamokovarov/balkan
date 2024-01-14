class AddSpeakerApplicationsEndDateToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :speaker_applications_end_date, :date, null: false, default: '2024-02-02'
  end
end
