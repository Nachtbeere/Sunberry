REDIS = Redis.new(host: ADDITIONAL_CONFIG["redis"]["host"],
                  port: ADDITIONAL_CONFIG["redis"]["port"],
                  db: ADDITIONAL_CONFIG["redis"]["db"])
