class Article < ApplicationRecord
  belongs_to :user
  has_many :replies
  has_rich_text :content
  acts_as_punchable

  def same_category?(category)
    self.category == category
  end

  def same_author?(author_id)
    user_id == author_id
  end

  def self.get_by_page(page, category)
    Article.page(page).per(10).order(id: :desc).where category: ADDITIONAL_CONFIG["article_categories"].find_index(category)
  end

  def self.latest(category)
    latest = Article.order(id: :desc).limit(5).where category: ADDITIONAL_CONFIG["article_categories"].find_index(category)
    latest.nil? ? [] : latest
  end
end
