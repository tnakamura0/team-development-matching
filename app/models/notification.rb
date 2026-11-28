class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :application

  enum :action, {
    applied: "applied",
    approved: "approved",
    rejected: "rejected"
  }, validate: true

  validates :action, uniqueness: { scope: :application_id }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
