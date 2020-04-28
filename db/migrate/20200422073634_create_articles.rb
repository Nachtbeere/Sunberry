class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.integer :category
      t.integer :tag
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
