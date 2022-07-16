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

    class LogSubscriber < ActiveSupport::LogSubscriber
      class_attribute :odd_color, :even_color

      def initialize
        super
        @odd = false
      end

      # Format a message for logging
      #
      # @param event [ActiveSupport::Notifications::Event] subscribed event
      # @param label [String] label for log messages
      # @param body [String] the rest
      # @return [String] formatted message for logging
      #  # => "  Test (0.00ms)  message body"
      def message(event, label, body)
        @odd = !@odd
        label_color = @odd ? odd_color : even_color

        format(
          '  %s (%.2fms)  %s',
          color(label, label_color, true),
          event.duration,
          color(body, nil, !@odd)
        )
      end

      # Set colors for logging title and duration
      def self.color(odd, even = nil)
        self.odd_color = odd
        self.even_color = even || odd
      end

      def format_arguments(args)
        args.map do |arg|
          if arg.respond_to?(:encoding) && arg.encoding == Encoding::ASCII_8BIT
            "<BINARY DATA>"
          else
            arg
          end
        end.join(" ")
      end
    end

    log_s = LogSubscriber.new
    LogSubscriber.color ActiveSupport::LogSubscriber::RED

    ActiveSupport::Notifications.subscribe "command.redis" do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      next unless log_s.logger.debug?
      cmds = event.payload[:commands]

      output = cmds.map do |name, *args|
        if !args.empty?
          "[ #{name.to_s.upcase} #{log_s.format_arguments(args)} ]"
        else
          "[ #{name.to_s.upcase} ]"
        end
      end.join(" ")

      log_s.logger.debug log_s.message(event, "Redis", output)
    end
  end
end

Redis::Client.send(:prepend, Redis::Instrumentation::Logging)
