class AddNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    change_column_default :users, :name, from: "", to: nil
  end
end
