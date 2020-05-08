class CreateOnelines < ActiveRecord::Migration[6.0]
  def change
    create_table :onelines do |t|
      t.integer :user_id
      t.string :content
      t.datetime :created_at
    end
  end
end
