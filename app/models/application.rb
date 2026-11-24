class Application < ApplicationRecord
  belongs_to :recruitment
  belongs_to :user
  has_many :notifications, dependent: :destroy

  enum :status, {
    pending: "pending",
    approved: "approved",
    rejected: "rejected"
  }

  validates :user_id, uniqueness: { scope: :recruitment_id }
  validate :cannot_apply_to_own_recruitment
  validate :recruitment_must_be_open, on: :create
  validate :must_be_pending, on: :update
  validate :positions_must_remain, on: :update

  def approve
    update(status: :approved)
  end

  def reject
    update(status: :rejected)
  end

  private

  def must_be_pending
    if status_changed? && status_was != "pending"
      errors.add(:base, :already_processed)
    end
  end

  def positions_must_remain
    if status_changed? && approved? && recruitment.remaining_positions_count.zero?
      errors.add(:base, :no_remaining_positions)
    end
  end

  def cannot_apply_to_own_recruitment
    if user_id == recruitment&.user_id
      errors.add(:base, :cannot_apply_to_own_recruitment)
    end
  end

  def recruitment_must_be_open
    return if recruitment.nil?

    unless recruitment.accepting_applications && recruitment.closing_date >= Date.current
      errors.add(:base, :recruitment_closed)
    end
  end
end
