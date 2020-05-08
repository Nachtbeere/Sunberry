class OnelineController < ApplicationController
  def get
    page = params[:page] || 1
    @onelines = Oneline.get_by_page(page)
    render 'oneline/list'
  end

  def create
    redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return if current_user.nil?

    if Oneline.duplicated?(current_user.id, params[:content])
      redirect_to '/oneline', flash: { alert: '이미 작성한 글입니다' }
    elsif Oneline.need_cooldown?(current_user.id)
      redirect_to '/oneline', flash: { alert: '너무 자주 작성했습니다' }
    elsif Oneline.attachment_overflow?(params[:images])
      redirect_to '/oneline', flash: { alert: '첨부파일이 너무 많아요!' }
    elsif Oneline.attachment_overload?(params[:images])
      redirect_to '/oneline', flash: { alert: '첨부파일이 너무 커요!' }
    else
      write_at = Time.now
      oneline = Oneline.create(
        content: params[:content],
        user_id: current_user.id,
        created_at: write_at
      )
      params[:images]&.each do |image|
        oneline.images.attach(Oneline.convert_image(image))
      end
      if oneline.save
        redirect_to '/oneline', flash: { info: '작성했습니다' }
      elsif params[:content].length > 280
        redirect_to '/oneline', flash: { alert: '글자수 제한을 초과했습니다' }
      else
        redirect_to '/oneline', flash: { alert: '작성 실패했습니다' }
      end
    end
  end

  def delete
    if current_user.nil?
      redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return
    end

    oneline = Oneline.find_by(id: params[:id])
    if !oneline.nil? && oneline.same_author?(current_user.id)
      oneline.is_removed = true
      oneline.save
      redirect_to '/oneline', flash: { info: '삭제 되었습니다' }
    else
      redirect_to '/oneline', flash: { alert: '잘못된 요청입니다' }
    end
  end

  private
  def oneline_params
    params.require(:oneline).permit(:content, images: [])
  end
end
