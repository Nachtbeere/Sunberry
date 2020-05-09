class Oneline < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :content,
            presence: true,
            allow_blank: false,
            length: { maximum: 280 }

  def self.get_by_page(page)
    Oneline.page(page).per(20).order(id: :desc).where(is_removed: false)
  end

  def self.latest()
    latest = Oneline.order(id: :desc).limit(5).all
    latest.nil? ? [] : latest
  end



  def self.duplicated?(author_id, content)
    Oneline.where(created_at: Time.now.utc.to_date.all_day).find_by(user_id: author_id, content: content)
  end

  def self.need_cooldown?(author_id)
    records = Oneline.limit(5).where(created_at: (Time.now.utc.to_datetime - 5.minutes)..Time.now.utc.to_datetime, user_id: author_id)
    records&.many? && records.size == 5
  end

  def self.attachment_overflow?(files)
    files.size > 4 unless files.nil?
  end

  def self.attachment_overload?(files)
    files&.each do |file|
      return File.size(file.tempfile.path) > 5_242_880
    end
  end

  def same_author?(author_id)
    user_id == author_id
  end

  def self.convert_image(image)
    resize = MiniMagick::Image.new(image.tempfile.path)
    resize.resize "800x500>"
    image.original_filename = new_filename(image)
    image
  end
end
