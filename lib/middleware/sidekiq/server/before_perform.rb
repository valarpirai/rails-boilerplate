module Middleware
  module Sidekiq
    module Server
	    class BeforePerform

        def call(worker, msg, queue)
          RequestStore.clear!
          params = msg['args'].first
          params.symbolize_keys! if params.is_a?(Hash)
          msg['start_time'] = Time.now
          Rails.logger.tagged(msg['jid']) do
            yield
          end
          msg['response_time'] = (Time.now - msg['start_time']).round(2)
          log_details(msg, params)
        ensure
          RequestStore.clear!
        end

        private
          def log_details(msg, params)
            account_id = msg['account_id'] || params[:account_id]
            enqueued_at = Time.at (msg['created_at'] || Time.now)
            AppLogger.sidekiq_bb("wkr=#{msg['class']},q=#{msg['queue']},a=#{account_id},r=#{msg['response_time']},\
            j=#{msg['jid']},uid=#{msg['uuid']},et=#{enqueued_at},pt=#{msg['start_time']},st=200")
          end
      end
    end
  end
end
