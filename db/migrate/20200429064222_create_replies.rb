class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.integer :user_id
      t.integer :article_id
      t.string :content
      t.datetime :created_at
    end
  end
end
