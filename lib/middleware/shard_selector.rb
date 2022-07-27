require "#{Rails.root}/lib/sharding"
module Middleware
  class ShardSelector
    RESPONSE_HEADERS = { 'Content-Type' => 'application/json' }

    def initialize(app)
      @app = app
    end

    def call(env)
      @host = Rails.env.development? ? env["HTTP_HOST"].split(':')[0] : env["HTTP_HOST"]
      Sharding.select_shard_of(@host) do |shard_name|
        Thread.current[:shard_name_payload] = shard_name
        @app.call(env)
      end
    rescue ActiveRecord::RecordNotFound => e
      # return 404 error
      @status, @headers, @response = [404, RESPONSE_HEADERS, [e.message]]
    end
  end
end
