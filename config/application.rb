# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# TODO - Multipart Limit size

module FlagManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    config.time_zone = 'Chennai'

    config.autoload_paths += ["#{config.root}/lib/"]

    config.hosts << "*.myapp-dev.com"
    config.hosts << "localhost.myapp-dev.com"

    # Active record Mass assignment
    # config.active_record.whitelist_attributes = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.middleware.delete "ActiveRecord::QueryCache"

    # Load all the Middlewares
    Dir["#{Rails.root}/lib/middleware/**/*"].each do |file|
      require file if file.end_with?('.rb')
    end

    config.middleware.use ::Middleware::RouteChecker
    config.middleware.use ::Middleware::ShardSelector

    config.session_store :cookie_store, key: '_myapp_session', httponly: true
  end
end
