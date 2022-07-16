# TODO - Subscribe to ActionController and ActiveRecord logs
# Print SQL Queries in Prod
# patching this to enable query logging in :info mode
# currently, there's no way to override this apart from patching.
module ActiveRecord
  class LogSubscriber < ActiveSupport::LogSubscriber
    class_attribute :odd_color, :even_color
    @@odd = false

    # Set colors for logging title and duration
    def self.color(odd, even = nil)
      self.odd_color = odd
      self.even_color = even || odd
    end

    def sql(event)
      self.class.runtime += event.duration
      return unless logger.info?

      payload = event.payload
      shard_name = payload[:shard_name]

      return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

      name  = "#{payload[:name]} (#{event.duration.round(1)}ms)"
      sql   = payload[:sql]

      shard = shard_name ? "[Shard: #{shard_name}]" : ""
      if Rails.env.development?
        @@odd = !@@odd
        n_c = @@odd ? odd_color : even_color
        shard = color(shard, RED, true)
        name = color(name, n_c, true)
        sql  = color(sql, CYAN, true)
      end

      backtrace = Rails.backtrace_cleaner.clean caller
      # Exclude patches
      relevant_caller_line = backtrace.detect do |caller_line|
        !caller_line.include?('/hacks/') || !caller_line.include?('/gems/')
      end

      info "#{shard} #{name}  #{sql}"
      if relevant_caller_line
        logger.debug("    ↳ #{relevant_caller_line.sub("#{Rails.root}/", '')}")
      end
    end
  end
end

ActiveRecord::LogSubscriber.color(ActiveSupport::LogSubscriber::MAGENTA, ActiveSupport::LogSubscriber::GREEN)
