class User < ApplicationRecord
  ROLES = { 'admin': 0, 'special': 1, 'general': 99 }
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
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
    logger.debug ROLES
    logger.debug "admin??"
    role == ROLES[:admin]
  end
end
