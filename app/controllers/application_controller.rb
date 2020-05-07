class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  before_action :set_protocol if Rails.env.production?

  def set_protocol
    Rails.application.routes.default_url_options[:protocol] = 'https'
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
