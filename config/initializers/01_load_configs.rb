def config_file(file_name, env = false)
    return YAML.load_file(File.join(Rails.root, 'config', file_name))[Rails.env] if env
    YAML.load_file(File.join(Rails.root, 'config', file_name))
end

AppConfig = config_file('config.yml').with_indifferent_access

redis_config = config_file('redis.yml')

RedisConfig = redis_config['main'][Rails.env]

RateLimitConfig = redis_config['rate_limit'][Rails.env]

redis_connection = Redis.new RedisConfig
$global_redis = Redis::Namespace.new(:gl, redis: redis_connection)

