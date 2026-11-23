class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :recruitments, dependent: :destroy
  has_many :applications, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 },
                            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true, length: { maximum: 50 }

  # パスワードを変更しない更新(passwordがnil)では長さチェックしない
  validates :password, length: { minimum: 8 }, allow_nil: true
end
