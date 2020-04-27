class MainController < ApplicationController
  def index
    @articles_notice = Article.get_latest(ADDITIONAL_CONFIG["article_categories"][0])
    @articles_general = Article.get_latest(ADDITIONAL_CONFIG["article_categories"][1])
    render 'main/index'
  end
end
