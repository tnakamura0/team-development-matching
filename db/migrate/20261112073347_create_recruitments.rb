class CreateRecruitments < ActiveRecord::Migration[8.1]
  def change
    create_table :recruitments do |t|
      t.string :title
      t.text :body
      t.date :closing_date
      t.integer :positions_count
      t.string :required_status
      t.boolean :accepting_applications
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
