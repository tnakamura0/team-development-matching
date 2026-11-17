class Application < ApplicationRecord
  belongs_to :recruitment
  belongs_to :user

  enum :status, {
    pending: "pending",
    approved: "approved",
    rejected: "rejected"
  }

  validates :user_id, uniqueness: { scope: :recruitment_id }
  validate :cannot_apply_to_own_recruitment
  validate :recruitment_must_be_open

  private

  def cannot_apply_to_own_recruitment
    if user_id == recruitment&.user_id
      errors.add(:user, "は募集作成者のため応募できません")
    end
  end

  def recruitment_must_be_open
    return if recruitment.nil?

    unless recruitment.accepting_applications && recruitment.closing_date >= Date.current
      errors.add(:base, "この応募は締め切られています")
    end
  end
end
