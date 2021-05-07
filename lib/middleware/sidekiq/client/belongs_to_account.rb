module Middleware
  module Sidekiq
    module Client
      class BelongsToAccount

        def call(worker, msg, queue, redis_pool)
          # do not set account id again - retry/scheduled
          if msg['belongs_to_account'] && !msg['account_id']
            msg['account_id'] = Account.current.id
          end
          yield
        end
      end
    end
  end
end
