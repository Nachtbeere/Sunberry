class ApiMinecraftController < ApplicationController
  require 'net/http'

  def get_uuid_by_name
    nil
  end

  def get_name_by_uuid

  end

  def get_server_info
    target = params[:server]
  end
end
