class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :application

  enum :action, {
    applied: "applied",
    approved: "approved",
    rejected: "rejected"
  }, validate: true

  validates :action, uniqueness: { scope: :application_id }
  validate :cannot_notify_yourself

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end

  private

  def cannot_notify_yourself
    if recipient_id.present? && recipient_id == actor_id
      errors.add(:base, :cannot_notify_yourself)
    end
  end
end
