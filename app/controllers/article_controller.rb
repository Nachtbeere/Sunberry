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
    redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return if current_user.nil?

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

  def modify_page
    redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return if current_user.nil?

    article_id = params[:id]
    category = params[:category]
    article = Article.find article_id
    if !article.nil? && article.user_id == current_user.id
      @article = article
      render 'article/modify'
    else
      if category == 'notice'
        redirect_to '/notice', flash: { alert: "존재하지 않는 글입니다" }
      else
        redirect_to '/board', flash: { alert: "존재하지 않는 글입니다" }
      end
    end
  end

  def modify
    redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return if current_user.nil?

    article_id = params[:id]
    category = params[:category]
    unless article_id.nil?
      update_at = Time.now
      article = Article.find article_id
      if !article.nil? && article.user_id == current_user.id
        article.title = params['article#modify'][:title]
        article.content = params['article#modify'][:content]
        article.updated_at = update_at
        article.save
      end
    end
    if category == 'notice'
      redirect_to '/notice'
    else
      redirect_to '/board'
    end
  end

end
