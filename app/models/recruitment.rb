class Recruitment < ApplicationRecord
  belongs_to :user

  enum :required_status,
    {
      basic_step_completed: "basic_step_completed",
      advanced_step_completed: "advanced_step_completed",
      graduated: "graduated"
    }, validate: true

  validates :title, presence: true
  validates :closing_date, presence: true
  validates :positions_count, presence: true
  validates :accepting_applications, inclusion: [ true, false ]
end
