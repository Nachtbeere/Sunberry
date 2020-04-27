class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :author_id
      t.string :title
      t.string :content
      t.integer :category
      t.integer :tag
      t.integer :hits
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
