module Middleware
  class DisableAssetsLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index('/assets/') == 0
      @app.call(env)
    ensure
      Rails.logger.level = previous_level
    end
  end
end