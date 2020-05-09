class ReplyController < ApplicationController
  def write
    redirect_to('/sign-in', flash: { alert: '로그인 해주세요' }) && return if current_user.nil?

    reply = Reply.create(
      article_id: params[:id],
      user_id: current_user.id,
      content: params['reply#write'][:content],
      created_at: Time.now
    )
    if reply.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path, flash: { alert: '댓글 작성에 실패했습니다' }
    end
  end
end
