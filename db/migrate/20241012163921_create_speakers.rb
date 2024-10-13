class CreateSpeakers < ActiveRecord::Migration[7.1]
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.string :bio
      t.string :github_url
      t.string :social_url

      t.timestamps
    end
  end
end
