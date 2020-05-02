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
      @article.punch(request)
      @board_name = ADDITIONAL_CONFIG['article_categories'][@article.category]
      if @board_name == 'notice'
        unless request.env['PATH_INFO'].include? @board_name
          redirect_to '/', flash: { alert: '잘못된 요청입니다' }
        end
      end
    rescue ActiveRecord::RecordNotFound => e
      redirect_to '/', flash: { alert: '잘못된 요청입니다' }
    end
  end

  def write_page
    render 'article/write'
  end

  def write
    category = params[:category]
    write_at = Time.now
    article = Article.create(
      title: params['article#write'][:title],
      content: params['article#write'][:content],
      user_id: current_user.id,
      category: ADDITIONAL_CONFIG[:article_categories].find_index(category),
      tag: 0, # fix later
      created_at: write_at,
      updated_at: write_at
    )
    article.save
    if category == 'notice'
      redirect_to '/notice'
    else
      redirect_to '/board'
    end
  end

  def article_params
    params.require(:article).permit(:content)
  end

  def modify
    render 'article/modify'
  end

end
