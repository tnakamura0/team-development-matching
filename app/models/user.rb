class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :recruitments, dependent: :destroy
  has_many :applications, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true, length: { maximum: 50 }

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
    "basic_step_completed" => "basic_step_completed",
    "advanced_step_completed" => "advanced_step_completed",
    "graduated" => "graduated"
  }.freeze

  def required_status_label
    I18n.t(".enums.recruitment.required_status.#{required_status}")
  end
end
