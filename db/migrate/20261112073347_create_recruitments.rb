class CreateRecruitments < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitments do |t|
      t.string :title, null: false
      t.text :body
      t.date :closing_date, null: false
      t.integer :positions_count, null: false
      t.string :required_status, null: false
      t.boolean :accepting_applications, null: false, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
