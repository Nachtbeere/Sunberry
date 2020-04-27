class ArticleController < ApplicationController
  CATEGORIES = %w[notice general].freeze

  def list
    category = params[:category]
    @board_name = category
    @articles = Article.where category: CATEGORIES.find_index(category)
  end

  def view
    article_id = params[:id]
    begin
      @article = Article.find article_id
      @board_name = CATEGORIES[@article.category]
    rescue ActiveRecord::RecordNotFound => e
      redirect_to '/', flash: { alert: '잘못된 요청입니다' }
    end
  end
end
