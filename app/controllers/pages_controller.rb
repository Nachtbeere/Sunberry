class PagesController < ApplicationController
  after_action :allow_iframe, only: [:show]

  def show
    render template: "pages/#{params[:page]}"
  end

  private
  def allow_iframe
    url = "http://maps.minecraft.nightly.nachtbeere.net"
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{url}"
    response.headers['Content-Security-Policy'] = "frame-ancestors #{url}"
  end
end
