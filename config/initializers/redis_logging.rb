require "redis"
require "active_support"

class Redis
  module Instrumentation
    module Logging
      def logging(commands, &block)
        ActiveSupport::Notifications.instrument("command.redis", commands: commands) do
          return super(commands, &block)
        end
      end
    end
  end
end

Redis::Client.send(:prepend, Redis::Instrumentation::Logging)
