module Middleware
  class ShardSelector
    RESPONSE_HEADERS = { 'Content-Type' => 'application/json' }

    def initialize(app)
      @app = app
    end

    def call(env)
      domain_mapping = lookup_account(env)
      fetch_shard(domain_mapping)

      ApplicationRecord.on_shard(env['SHARD'].id) do
        @app.call(env)
      end
    rescue ActiveRecord::RecordNotFound => e
      # return 404 error
      @status, @headers, @response = [404, RESPONSE_HEADERS, [e.message]]
    end

    def fetch_shard
      env['SHARD'] ||= ShardMapping.lookup_with_domain(domain_mapping.domain)
    end

    def lookup_account(env)
      # Account Lookup
      DomainMapping.find_by(domain: env['host'])
    end
  end
end
