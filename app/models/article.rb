class Article < ApplicationRecord
  belongs_to :user
  has_many :replies
  has_rich_text :content
  acts_as_punchable

  def self.get_by_page(page, category)
    Article.page(page).per(10).order(id: :desc).where category: ADDITIONAL_CONFIG["article_categories"].find_index(category)
  end

  def self.latest(category)
    latest = Article.order(id: :desc).limit(5).where category: ADDITIONAL_CONFIG["article_categories"].find_index(category)
    if latest.nil?
      []
    else
      latest
    end
  end
end
