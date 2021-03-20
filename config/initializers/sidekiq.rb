redis_conn = proc {
  Redis.new(RedisConfig) # do anything you want here
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 30, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 50, &redis_conn)
end
