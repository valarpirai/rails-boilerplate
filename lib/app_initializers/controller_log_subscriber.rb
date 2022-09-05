class ControllerLogSubscriber <  ActiveSupport::LogSubscriber

  # http://www.paperplanes.de/2012/3/14/on-notifications-logsubscribers-and-bringing-sanity-to-rails-logging.html

  def process_action(event)
    event.payload[:duration] = event.duration
    # Rails.logger.app_logger(logging_format(event.payload))
    Rails.logger.debug(logging_format(event.payload))
  end

  def logging_format(payload)
    performance_metrics = {} # Collect other metrics

    # puts payload.keys.inspect
    payload[:db_runtime] = payload[:db_runtime].round(2) if payload[:db_runtime]
    payload[:view_runtime] = payload[:view_runtime].round(2) if payload[:view_runtime]
    payload[:duration] = payload[:duration].round(2)
    ip = payload[:ip] || payload[:remote_ip]
    redis_calls = payload[:redis_calls].values.inject(:+)
    active_record_calls = payload[:active_record_calls].values.inject(:+)

    log_data = { ip: ip,
      uid: payload[:uuid],
      a: payload[:account_id],
      usr: payload[:user_id],
      s: payload[:shard_name],
      # u: payload[:url],
      d: payload[:domain],
      p: payload[:path],
      c: payload[:controller],
      acn: payload[:action],
      sip: payload[:server_ip],
      st: payload[:status],
      f: payload[:format],
      dbt: payload[:db_runtime],
      dbc: active_record_calls,
      vw: payload[:view_runtime],
      rt: payload[:redis_time].round(2),
      rc: redis_calls,
      mc: performance_metrics[:memcache_calls],
      mdr: performance_metrics[:memcache_dup_reads],
      mt: performance_metrics[:memcache_time],
      drn: payload[:duration]
    }
    "[INSTRUMENT] #{log_data.to_json}"
  end
end

ControllerLogSubscriber.attach_to :action_controller
