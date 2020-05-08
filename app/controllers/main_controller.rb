class MainController < ApplicationController
  def index
    @articles_notice = Article.latest(ADDITIONAL_CONFIG["article_categories"][0])
    @onelines = Oneline.latest
    render 'main/index'
  end
end
