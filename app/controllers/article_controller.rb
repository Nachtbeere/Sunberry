class ArticleController < ApplicationController
  def list
    category = params[:category]
    page = params[:page] || 1
    @board_name = category
    @articles = Article.get_by_page(page, category)
  end

  def view
    article_id = params[:id]
    begin
      @article = Article.find article_id
      @board_name = ADDITIONAL_CONFIG["article_categories"][@article.category]
    rescue ActiveRecord::RecordNotFound => e
      redirect_to '/', flash: { alert: '잘못된 요청입니다' }
    end
  end
end
