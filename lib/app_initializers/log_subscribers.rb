# TODO - Subscribe to ActionController and ActiveRecord logs
# Print SQL Queries in Prod
# patching this to enable query logging in :info mode
# currently, there's no way to override this apart from patching.
module ActiveRecord
  class LogSubscriber < ActiveSupport::LogSubscriber
    def sql(event)
      self.class.runtime += event.duration
      return unless logger.info?

      payload = event.payload

      return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

      name  = "#{payload[:name]} (#{event.duration.round(1)}ms)"
      sql   = payload[:sql]
      binds = nil

      unless (payload[:binds] || []).empty?
        binds = "  " + payload[:binds].map { |col,v|
          render_bind(col, v)
        }.inspect
      end

      if Rails.env.development?
        l_c = odd? ? CYAN : MAGENTA
        name = color(name, l_c, true)
        sql  = color(sql, l_c, true)
      end

      info "  #{name}  #{sql}#{binds}"
    end
  end
end