class User < ApplicationRecord
  ROLES = { 'admin': 0, 'special': 1, 'general': 99 }.freeze
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  PASSWORD_REQUIREMENTS = /\A(?=.{6,})(?=.*\d)(?=.*[a-z])/x.freeze
  validates :username,
            presence: true,
            allow_blank: false,
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
            length: { minimum: 6 },
            if: :password
  has_secure_password
  has_one_attached :avatar

  def admin?
    role == ROLES[:admin]
  end

  def identity
    sliced_email = email.split('@')
    if admin?
      sliced_email[0].capitalize
    else
      Digest::MD5.hexdigest(sliced_email[0] + '#' + sliced_email[1][0])[0, 12]
    end
  end

  def username_identity
    username + '(' + identity + ')'
  end

  def username_hash
    Digest::MD5.hexdigest(username)[0, 12]
  end

  def identity_colour
    '#' + Digest::MD5.hexdigest(username)[0, 6]
  end

  def add_profile_image(profile_image)
    image = convert_profile_image(profile_image)
    avatar.attach(image)
  end

  def convert_profile_image(profile_image)
    image = MiniMagick::Image.new(profile_image.tempfile.path)
    image.resize "200x200>"
    profile_image.original_filename = username_hash + User.extract_extension(profile_image.tempfile.path)
    profile_image
  end

  def confirmation_token
    @confirmation_token ||= SecureRandom.urlsafe_base64.to_s
  end

  def verified?
    is_verified
  end

  def self.duplicated_uuid?(uuid)
    find_by(minecraft_uuid: uuid)
  end

  def get_minecraft_uuid
    minecraft_uuid.blank? ? '00000000000000000000000000000000' : minecraft_uuid
  end

  def self.get_by_page(page)
    User.page(page).per(10).order(id: :desc).all
  end
end
