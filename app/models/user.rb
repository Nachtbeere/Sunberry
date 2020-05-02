class User < ApplicationRecord
  ROLES = { 'admin': 0, 'special': 1, 'general': 99 }.freeze
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  PASSWORD_REQUIREMENTS = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[[:^alnum:]])/x.freeze
  validates :username,
            presence: true,
            length: { maximum: 32 }
  validates :email,
            presence: true,
            length: { maximum: 256 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :minecraft_uuid,
            uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password,
            format: { with: PASSWORD_REQUIREMENTS },
            length: { minimum: 8 },
            if: :password
  has_secure_password

  def admin?
    role == ROLES[:admin]
  end

  def identity
    sliced_email = email.split('@')
    if admin?
      sliced_email[0].capitalize
    else
      sliced_email[0] + '#' + sliced_email[1][0]
    end
  end

  def username_identity
    username + '(' + identity + ')'
  end

  def confirmation_token
    @confirmation_token ||= SecureRandom.urlsafe_base64.to_s
  end

  def self.get_by_page(page)
    User.page(page).per(10).order(id: :desc).all
  end
end
