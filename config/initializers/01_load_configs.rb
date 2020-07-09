AppConfig = YAML.load_file(File.join(Rails.root, 'config', 'config.yml')).with_indifferent_access

# RateLimitConfig = YAML.load_file(File.join(Rails.root, 'config', 'redis.yml'))["rate_limit"][Rails.env]

# MobileConfig = YAML.load_file(File.join(Rails.root, 'config', 'mobile_config.yml'))

# AdminApiConfig = YAML.load_file(File.join(Rails.root,'config','fdadmin_api_config.yml'))

# PodConfig = YAML.load_file(File.join(Rails.root, 'config', 'pod_info.yml'))

# TaskSchedulerConfig = YAML.load_file(File.join(Rails.root, 'config', 'task_scheduler.yml'))[Rails.env]
