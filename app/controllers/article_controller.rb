class ArticleController < ApplicationController
  def list
    category = params[:category]
    @board_name = category.capitalize
    @articles = Article.find_by category: Article::CATEGORIES.find_index(category)
  end
end
