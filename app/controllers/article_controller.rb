class ArticleController < ApplicationController
  CATEGORIES = ['notice'].freeze

  def list
    category = params[:category]
    @board_name = category
    @articles = Article.where category: CATEGORIES.find_index(category)
  end

  def view
    category = params[:category]
    article_id = params[:id]
    @board_name = category
    @article = Article.find article_id
    logger.debug @article
  end
end
