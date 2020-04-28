class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :role
      t.boolean :is_verified, default: false
      t.string :minecraft_username
      t.string :minecraft_uuid
      t.datetime :created_at
      t.datetime :login_at
    end
  end
end
