class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :recruitments, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true

  validates :period, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }

  # パスワードを変更しない更新(passwordがnil)では長さチェックしない
  validates :password, length: { minimum: 8 }, allow_nil: true

  enum :required_status,
    {
      basic_step_completed: "basic_step_completed",
      advanced_step_completed: "advanced_step_completed",
      graduated: "graduated"
    }, validate: true

  REQUIRED_STATUS_LABELS = {
    "basic_step_completed" => "基礎STEP完了",
    "advanced_step_completed" => "応用STEP完了",
    "graduated" => "卒業済み"
  }.freeze

  def required_status_label
    REQUIRED_STATUS_LABELS[required_status]
  end
end
