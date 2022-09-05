require "redis"
require "active_support"

# MonkeyPatch Redis client to emit ActiveSupport Notification
class Redis
  module Instrumentation
    module Logging
      def logging(commands, &block)
        ActiveSupport::Notifications.instrument("command.redis", commands: commands) do
          super(commands, &block)
        end
      end
    end
  end
end

Redis::Client.send(:prepend, Redis::Instrumentation::Logging)
