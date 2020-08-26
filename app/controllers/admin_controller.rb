class AdminController < ApplicationController
  def index
    redirect_to('/') && return if current_user.nil?
    redirect_to('/') && return unless current_user.admin?

    minecraft_server_health
    render 'admin/index'
  end

  def users
    redirect_to('/') && return if current_user.nil?
    redirect_to('/') && return unless current_user.admin?

    page = params[:page] || 1
    @users = User.get_by_page(page)

    render 'admin/users'
  end

  def toolbox
    redirect_to('/') && return if current_user.nil?
    redirect_to('/') && return unless current_user.admin?

    render 'admin/toolbox'
  end

  def mail_test
    UserMailer.with(user: current_user, token: 'test').confirm_email.deliver_now
  end

  def minecraft_server_health
    servers = ADDITIONAL_CONFIG['purifier_api']['host'].keys
    @health = {}
    servers.each do |s|
      @health[s] = Purifier.server_health(s)
    end
  end
end
