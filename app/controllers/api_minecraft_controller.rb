class ApiMinecraftController < ApplicationController
  def uuid_from_name
    not_found && return unless server_param_validate
    render json: Purifier.uuid_from_name(params[:server],
                                         params[:username])
  end

  def name_from_uuid
    not_found && return unless server_param_validate
    render json: Purifier.name_from_uuid(params[:server],
                                         params[:uuid])
  end

  def server_health
    not_found && return unless server_param_validate
    render json: Purifier.server_health(params[:server])
  end

  def server_info
    not_found && return unless server_param_validate
    render json: Purifier.server_info(params[:server])
  end

  def server_system_info
    not_found && return unless server_param_validate
    render json: Purifier.server_system_info(params[:server])
  end

  private
  def server_param_validate
    if params[:server] == 'mainline'
      ADDITIONAL_CONFIG['purifier_api']['host'].key?('mainline_survival')
    else
      ADDITIONAL_CONFIG['purifier_api']['host'].key?(params[:server])
    end
  end

  def not_found
    render json: nil, status: 404
  end

  def internal_server_error
    render json: nil, status: 500
  end


end
