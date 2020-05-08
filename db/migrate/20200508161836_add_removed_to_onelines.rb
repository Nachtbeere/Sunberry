class AddRemovedToOnelines < ActiveRecord::Migration[6.0]
  def change
    add_column :onelines, :is_removed, :boolean, default: false
  end
end
