module Middleware
  class ShardSelector
    RESPONSE_HEADERS = { 'Content-Type' => 'application/json' }

    def initialize(app)
      @app = app
    end

    def call(env)
      @host = Rails.env.development? ? env["HTTP_HOST"].split(':')[0] : env["HTTP_HOST"]
      env['SHARD'] = fetch_shard(@host)

      ApplicationRecord.on_shard(env['SHARD'].id) do
        @app.call(env)
      end
    rescue ActiveRecord::RecordNotFound => e
      # return 404 error
      @status, @headers, @response = [404, RESPONSE_HEADERS, [e.message]]
    end

    def fetch_shard(domain)
      ShardMapping.lookup(domain)
    end
  end
end
