class ApiMinecraftController < ApplicationController
  def uuid_from_name
    not_found unless server_param_validate
    render json: Purifier.uuid_from_name(params[:server],
                                         params[:username])
  end

  def name_from_uuid
    not_found unless server_param_validate
    render json: Purifier.name_from_uuid(params[:server],
                                         params[:uuid])
  end

  def server_health
    not_found unless server_param_validate
    render json: Purifier.server_health(params[:server])
  end

  def server_info
    not_found unless server_param_validate
    render json: Purifier.server_info(params[:server])
  end

  def server_system_info
    not_found unless server_param_validate
    render json: Purifier.server_system_info(params[:server])
  end

  private
  def server_param_validate
    ADDITIONAL_CONFIG['purifier_api']['host'].key?(params[:server])
  end

  def not_found
    render json: nil, status: 404
  end

  def internal_server_error
    render json: nil, status: 500
  end


end
