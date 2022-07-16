require 'request_store'
require 'securerandom'
require 'active_support/log_subscriber'
require 'active_support/concern'
require 'active_support/core_ext/module/attr_internal'

module Notifications
  # LogSubscriber with runtime calculation and improved logging
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
    #
    # ==== Examples
    #
    #  event :test do |event|
    #    message(event, 'Test', 'message body')
    #  end
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

    class << self
      # Store aggregated runtime form request specific store
      def runtime=(value)
        RequestStore.store["#{@name}_runtime"] = value
      end

      # Fetch aggregated runtime form request specific store
      def runtime
        RequestStore.store["#{@name}_runtime"] || 0
      end

      # Reset aggregated runtime
      #
      # @return Numeric previous runtime value
      def reset_runtime
        rt = runtime
        self.runtime = 0
        rt
      end

      # Set colors for logging title and duration
      def color(odd, even = nil)
        self.odd_color = odd
        self.even_color = even || odd
      end

      # Define an event subscriber
      #
      # @param command [Symbol] event name
      # @param runtime [Boolean] aggregate runtime for this event
      # @yield [ActiveSupport::Notifications::Event] handle event
      def event(command, runtime: true, &block)
        define_method command do |event|
          self.class.runtime += event.duration if runtime
          instance_exec(event, &block) if block
        end
      end

      protected

      def inherited(base)
        super
        base.class_eval do
          @name ||= SecureRandom.hex
        end
      end
    end
  end

  def self.generate_controller_runtime(name, log_subscriber)
    runtime_attr = "#{name.to_s.underscore}_runtime".to_sym
    Module.new do
      extend ActiveSupport::Concern
      attr_internal runtime_attr

      protected

      define_method :process_action do |action, *args|
        log_subscriber.reset_runtime
        super(action, *args)
      end

      define_method :cleanup_view_runtime do |&block|
        runtime_before_render = log_subscriber.reset_runtime
        send("#{runtime_attr}=",
             (send(runtime_attr) || 0) + runtime_before_render)
        runtime = super(&block)
        runtime_after_render = log_subscriber.reset_runtime
        send("#{runtime_attr}=", send(runtime_attr) + runtime_after_render)
        runtime - runtime_after_render
      end

      define_method :append_info_to_payload do |payload|
        super(payload)
        runtime = (send(runtime_attr) || 0) + log_subscriber.reset_runtime
        payload[runtime_attr] = runtime
      end

      const_set(:ClassMethods, Module.new do
        define_method :log_process_action do |payload|
          messages = super(payload)
          runtime = payload[runtime_attr]
          if runtime && runtime != 0
            messages << format("#{name}: %.1fms", runtime.to_f)
          end
          messages
        end
      end)
    end
  end

  def self.subscribe(name, label: nil, &block)
    label ||= name
    log_subscriber = Class.new(LogSubscriber, &block)
    log_subscriber.attach_to name.to_sym
    controller_runtime = generate_controller_runtime(label, log_subscriber)
    ActiveSupport.on_load(:action_controller) do
      include controller_runtime
    end
  end
end

Notifications.subscribe("redis", label: "Redis") do
  event :command do |event|
    next unless logger.debug?
    cmds = event.payload[:commands]

    output = cmds.map do |name, *args|
      if !args.empty?
        "[ #{name.to_s.upcase} #{format_arguments(args)} ]"
      else
        "[ #{name.to_s.upcase} ]"
      end
    end.join(' ')

    debug message(event, 'Redis', output)
  end

  private

  def format_arguments(args)
    args.map do |arg|
      if arg.respond_to?(:encoding) && arg.encoding == Encoding::ASCII_8BIT
        '<BINARY DATA>'
      else
        arg
      end
    end.join(' ')
  end
end

Notifications.subscribe("active_record", label: "ActiveRecord") do
  event :command do |event|
    next unless logger.debug?
    cmds = event.payload[:commands]
    debug message(event, 'ActiveRecord', cmds)
  end
end

