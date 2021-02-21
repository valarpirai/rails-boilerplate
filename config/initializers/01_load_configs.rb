AppConfig = YAML.load_file(File.join(Rails.root, 'config', 'config.yml')).with_indifferent_access

RedisConfig = YAML.load_file(File.join(Rails.root, 'config', 'redis.yml'))[Rails.env]
