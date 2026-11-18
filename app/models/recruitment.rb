class Recruitment < ApplicationRecord
  belongs_to :user
  has_many :applications, dependent: :destroy

  enum :required_status,
    {
      basic_step_completed: "basic_step_completed",
      advanced_step_completed: "advanced_step_completed",
      graduated: "graduated"
    }, validate: true

  validates :title, presence: true
  validates :closing_date, presence: true
  validates :positions_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :accepting_applications, inclusion: [ true, false ]

  def owned_by?(user)
    user.present? && user_id == user.id
  end

  def approved_applications_count
    applications.approved.count
  end

  def remaining_positions_count
    [positions_count - approved_applications_count, 0].max
  end
end
