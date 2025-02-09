class CreateBlogPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_posts do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.date :date
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
