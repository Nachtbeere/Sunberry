class User < ApplicationRecord
  ROLES = { 'admin': 0, 'special': 1, 'general': 99 }.freeze
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :username,
            presence: true,
            length: { maximum: 32 }
  validates :email,
            presence: true,
            length: { maximum: 256 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password

  def admin?
    role == ROLES[:admin]
  end

  def confirmation_token
    @confirmation_token ||= SecureRandom.urlsafe_base64.to_s
  end
end
