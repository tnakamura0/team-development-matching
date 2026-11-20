class AddRequiredStatusToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :required_status, :string
    change_column_null :users, :required_status, false, "basic_step_completed"
  end
end
