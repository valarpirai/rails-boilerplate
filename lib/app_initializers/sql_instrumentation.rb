
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
AppNotifications.subscribe("active_record", label: "ActiveRecord") do
  event :sql do |event|
    cmd = event.payload[:sql]
    # type = [:get, :set].include?(cmds.first.first) ? cmds.first.first : :other

    # puts cmds.start_with?
    type = cmd.split(' ')[0].downcase
    self.class.increment_call(type)
  end
end

# Try to get count alone for AR
