module Middleware
  class RouteChecker
    RESPONSE_HEADERS = { 'Content-Type' => 'application/json' }

    def initialize(app)
      @app = app
    end

    def call(env)
      # Rails.application.routes.recognize_path
      @app.call(env)
    rescue ActionController::RoutingError => e
      # return 404 error
      @status, @headers, @response = [404, RESPONSE_HEADERS, [e.message]]
    end
  end
end
