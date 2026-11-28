class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }, index: false
      t.references :application, null: false, foreign_key: true, index: false
      t.string :action, null: false
      t.datetime :read_at

      t.timestamps

      t.index [ :recipient_id, :created_at ]
      t.index [ :application_id, :action ], unique: true
    end
  end
end
