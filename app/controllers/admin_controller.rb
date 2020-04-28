class AdminController < ApplicationController
  def index
    redirect_to('/') && return if current_user.nil?
    redirect_to('/') && return unless current_user.admin?

    render 'admin/index'
  end

  def mail_test
    UserMailer.with(user: current_user, token: 'test').confirm_email.deliver_now
  end
end
