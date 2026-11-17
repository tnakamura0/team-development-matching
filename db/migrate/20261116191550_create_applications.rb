class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.references :recruitment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"

      t.timestamps

      t.index [:user_id, :recruitment_id], unique: true
    end
  end
end
