class AddSpeakerApplicationsUrlToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :speaker_applications_url, :string
  end
end
