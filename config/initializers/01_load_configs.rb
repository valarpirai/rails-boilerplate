def config_file(file_name)
    YAML.load_file(File.join(Rails.root, 'config', file_name))
end

AppConfig = config_file('config.yml').with_indifferent_access

redis_config = config_file('redis.yml')

RedisConfig = redis_config['main'][Rails.env]

RateLimitConfig = redis_config['rate_limit'][Rails.env]
