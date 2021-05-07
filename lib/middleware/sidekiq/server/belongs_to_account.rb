module Middleware
  module Sidekiq
    module Server
      class BelongsToAccount

        def call(worker, msg, queue)
          account_id = msg['account_id'] || msg['args'].first[:account_id]
          account_id = nil if msg['args'].first[:skip_shard]
          unless account_id
            yield # might return nil
            return
          end
          ::Account.reset_current_account
          Sharding.select_shard_of(account_id) do
            account = ::Account.find(account_id)
            account.make_current
            ::TimeZone.set_time_zone

            yield
          end
        end
      end
    end
  end
end
