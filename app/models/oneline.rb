class Oneline < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :content,
            presence: true,
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
    Oneline.limit(5).where(created_at: (Time.now.utc.to_datetime - 5.minutes)..Time.now.utc.to_datetime).find_by(user_id: author_id)
  end

  def same_author?(author_id)
    user_id == author_id
  end
end
