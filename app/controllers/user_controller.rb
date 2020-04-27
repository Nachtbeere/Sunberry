class UserController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sign_in_page, :sign_up_page]

  def sign_in_page
    redirect_to('/', flash: { alert: '이미 로그인되어 있습니다' }) && return if logged_in?

    render 'user/sign_in'
  end

  def sign_out
    if request.method_symbol == :post
      session[:user_id] = nil
      redirect_to '/', flash: { info: '로그아웃 되었습니다' }
    else
      redirect_to '/', flash: { alert: '잘못된 접근입니다' }
    end
  end

  def sign_in
    if request.method_symbol == :post
      user = User.find_by(email: params[:email].downcase)
      if user&.authenticate(params[:password])
        user.login_at = Time.now
        user.save
        session[:user_id] = user.id
        redirect_to '/', flash: { info: '로그인 되었습니다' }
      else
        redirect_to '/sign_in', flash: { alert: '이메일 주소나 비밀번호가 일치하지 않습니다' }
      end
    else
      redirect_to '/sign_in', flash: { alert: '잘못된 접근입니다' }
    end
  end

  def sign_up_page
    redirect_to('/', flash: { alert: '이미 가입되어 있습니다' }) && return if logged_in?

    render 'user/sign_up'
  end

  def sign_up
    logger.debug request.method
    if request.method_symbol == :post
      user = User.find_by(email: params[:email].downcase)
      redirect_to('/sign_up', flash: { alert: '이미 등록된 E-Mail입니다' }) && return if user

      if params[:password] == params[:password_confirmation]
        created_time = Time.now
        user = User.create(
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation],
          username: params[:username],
          minecraft_username: params[:minecraft_username],
          minecraft_uuid: params[:minecraft_uuid] || '',
          role: User::ROLES[:general],
          is_verified: false,
          created_at: created_time,
          login_at: created_time
        )
        if user.save
          UserMailer.with(user: user).confirm_email.deliver_later
          session[:user_id] = user.id
          redirect_to '/', flash: { alert: '회원가입 되었습니다' }
        else
          redirect_to 'user/sign_up', flash: { alert: '입력한 정보가 올바르지 않습니다' }
        end
      else
        redirect_to 'user/sign_up', flash: { alert: '입력한 정보가 올바르지 않습니다' }
      end
    else
      redirect_to '/sign_up', flash: { alert: '잘못된 접근입니다' }
    end
  end

  def profile_page
    render 'user/profile'
  end
end
