class Purifier
  def self.get_from_purifier_api(target_server, endpoint)
    info = get_purifier_from_redis(target_server, endpoint)
    unless info
      info = request_purifier_server(target_server, endpoint)
      set_purifier_to_redis(target_server, endpoint, info) if info
    end
    info
  end

  def self.get_from_mojang_api(endpoint)
    info = request_mojang_server(endpoint)
    info || nil
  end

  def self.name_from_uuid(server, uuid)
    info = get_from_purifier_api(server,
                                 ADDITIONAL_CONFIG['purifier_api']['users']['name'] +
                                 '/' + uuid)
    info ||= get_from_mojang_api(ADDITIONAL_CONFIG['mojang_api']['name_from_uuid'] +
                                 '/' + uuid + '/names')
    info
  end

  def self.uuid_from_name(server, username)
    info = get_from_purifier_api(server,
                                 ADDITIONAL_CONFIG['purifier_api']['users']['uuid'] +
                                '/' + username)
    info ||= get_from_mojang_api(ADDITIONAL_CONFIG['mojang_api']['uuid_from_name'] +
                                   '/' + username)
    info
  end

  def self.server_health(server)
    get_from_purifier_api(server,
                          ADDITIONAL_CONFIG['purifier_api']['server']['health'])
  end

  def self.server_info(server)
    get_from_purifier_api(server,
                          ADDITIONAL_CONFIG['purifier_api']['server']['info'])
  end

  def self.server_system_info(server)
    get_from_purifier_api(server,
                          ADDITIONAL_CONFIG['purifier_api']['server']['system_info'])
  end

  private

  def self.request_url(target_server, endpoint)
    target = if target_server == 'mainline'
      'mainline_survival'
             else
      target_server
             end
    URI.join ADDITIONAL_CONFIG['purifier_api']['host'][target],
             request_endpoint(endpoint)
  end

  def self.request_endpoint(endpoint)
    '/api/' + ADDITIONAL_CONFIG['purifier_api']['version'] +
        '/' + endpoint
  end

  def self.server_request(uri, port)
    Net::HTTP.new(uri, port)
  end

  def self.get_purifier_from_redis(target_server, endpoint)
    data = REDIS.get(ADDITIONAL_CONFIG['purifier_api']['redis_root'] +
                         target_server + ':' +
                         endpoint)
    Marshal.load(data) if data
  end

  def self.set_purifier_to_redis(target_server, endpoint, data)
    REDIS.set(ADDITIONAL_CONFIG['purifier_api']['redis_root'] +
                  target_server + ':' +
                  endpoint,
              Marshal.dump(data),
              { ex: expire(endpoint) })
  end

  def self.expire(endpoint)
    if endpoint.include? 'user/'
      30.days.to_i
    else
      30.seconds.to_i if endpoint.include? 'health'
      1.minutes.to_i
    end
  end

  def self.request_purifier_server(target_server, endpoint)
    uri = request_url(target_server, endpoint)
    resp = server_request(uri.host, uri.port).get(uri.path)
    JSON.parse(resp.body) if resp.is_a? Net::HTTPSuccess
      # req = server_request(uri.host, uri.port)
      # req.set_debug_output $stderr
      # req_path = Net::HTTP::Get.new(uri.path)
      # resp = req.start do |http|
      #   http.request(req_path)
  rescue SocketError => e
    puts e
    nil
  rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
         Errno::EHOSTUNREACH, Errno::ECONNREFUSED => e
    puts e
    nil
  end

  def self.request_mojang_server(endpoint)
    # fix later
    uri = URI.join ADDITIONAL_CONFIG['mojang_api']['host'], endpoint
    resp = Curl.get(uri.to_s).body_str
    JSON.parse(resp) if resp != ''
    end
end
