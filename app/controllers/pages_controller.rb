class PagesController < ApplicationController
  after_action :allow_iframe, only: [:show]

  def show
    if params[:page].include? 'minecraft_connect'
      server_info
    end
    render template: "pages/#{params[:page]}"
  end

  private

  def allow_iframe
    url = 'https://*.minecraft.' + ADDITIONAL_CONFIG['domain']
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{url}"
    response.headers['Content-Security-Policy'] = "frame-ancestors #{url}"
  end

  def server_info
    servers = ADDITIONAL_CONFIG['purifier_api']['host'].keys
    @health = {}
    @info = {}
    @system = {}
    servers.each do |s|
      @health[s] = Purifier.server_health(s)
      @info[s] = Purifier.server_info(s)
      @system[s] = Purifier.server_system_info(s)
      if @info[s]&.key?('version')
        @info[s]['version'] = @info[s]['version'].match('(?<=MC: ).*(?=\\))')
        puts @info[s]['version']
      end
    end
  end

end
