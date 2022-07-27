
# ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
#   event = ActiveSupport::Notifications::Event.new *args
#   # your own custom stuff
#   Rails.logger.info "#{event.name} Received! (duration: #{event.duration}" # process_action.action_controller Received (started: 1560978.425334, finished: 1560979.429234)
# end

# ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
#   event = ActiveSupport::Notifications::Event.new *args

#   payload = event.payload
#   # your own custom stuff
#   Rails.logger.info "#{payload[:name]}, (#{event.duration} ms) #{payload[:statement_name]}, #{payload[:cached]}"
# end


# This doesn't provide accurate duration(Monotonic) for ActiveRecord. But, we can use it for counting
# AppNotifications.subscribe("active_record", label: "ActiveRecord") do
#   event :sql do |event|
#     cmds = event.payload[:sql]
#     # type = [:get, :set].include?(cmds.first.first) ? cmds.first.first : :other
#     # self.class.increment_call(type)

#     puts cmds.inspect

#     next unless logger.debug?
#     payload = event.payload
#     shard_name = payload[:shard_name]

#     next if ActiveRecord::LogSubscriber::IGNORE_PAYLOAD_NAMES.include?(payload[:name])

#     name  = "#{payload[:name]} (#{event.duration.round(1)}ms)"
#     sql   = payload[:sql]

#     backtrace = Rails.backtrace_cleaner.clean caller
#     # Exclude patches
#     relevant_caller_line = backtrace.detect do |caller_line|
#       !caller_line.include?('/app_initializers/') || !caller_line.include?('/gems/')
#     end

#     debug "#{name} #{sql}"
#     if relevant_caller_line
#       debug("    ↳ #{relevant_caller_line.sub("#{Rails.root}/", '')}")
#     end
#   end
# end
