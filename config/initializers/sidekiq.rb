
config = config_file('sidekiq.yml', true)
sidekiq_config = config_file('sidekiq_client.yml', true)

redis_config = { 
  url: "redis://#{config['host']}:#{config['port']}", 
  network_timeout: sidekiq_config[:timeout], 
  namespace: config['namespace'] 
}
redis_config.merge!({password: config["password"]}) unless (Rails.env.development? || Rails.env.test? || ENV['RSPEC'])

redis_conn = proc {
  Redis.new(RedisConfig) # do anything you want here
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 30, &redis_conn)
  config.client_middleware do |chain|
    chain.add Middleware::Sidekiq::Client::BelongsToAccount
  end
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 50, &redis_conn)
  config.logger.level = ENV["LOGGING_LEVEL"] ? ENV["LOGGING_LEVEL"].to_sym : :info

  config.server_middleware do |chain|
    chain.add Middleware::Sidekiq::Server::BeforePerform
    chain.add Middleware::Sidekiq::Server::BelongsToAccount
  end

  # sidekiq server can also enqueue jobs
  config.client_middleware do |chain|
    chain.add Middleware::Sidekiq::Client::BelongsToAccount
  end
end
