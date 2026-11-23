class AddPeriodToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :period, :integer
    change_column_null :users, :period, false, 0
  end
end
