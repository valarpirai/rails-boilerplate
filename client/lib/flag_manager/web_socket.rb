require 'faye/websocket'
require 'eventmachine'

# ARGS - URL, API Key, Global Store
# Store is initialized and passed to WS Listener. On Flag change it will be updated - Thread Safe
# The Store is directly accessed from the APP


# Note - Don't use return inside EventMachine and other blocks
# 'ws://localhost.myapp-dev.com:3001/cable'
module FlagManager
  class WebSocket

    RETRY_TIME_WAIT = 2

    def initialize(url, api_key, event_processor, reconnect = true)
      @url = url
      @api_key = api_key
      @event_processor = event_processor
      @started = Concurrent::AtomicBoolean.new(false)
      @disconnected = Concurrent::AtomicBoolean.new(false)
      @reconnect = true
    end

    def start
      connect
    end
    def stop
      @reconnect = false
      if @worker && @worker.alive?
        Thread.kill(@worker)
      end
    end

    def connect
      return unless @started.make_true
      p 'start worker'
      @worker = Thread.new {
        EventMachine.run {
          auth_token = Base64.encode64( "#{@api_key}:x" ).chomp
          url = "#{@url}?token=#{auth_token}"
          ws = Faye::WebSocket::Client.new(url)

          ws.on :open do |event|
            p [:open]
            @disconnected.make_false
            ws.send(FlagManager::Config::SUBSCRIBE_COMMAND)
          end

          ws.on :message do |event|
            data = Oj.load(event.data)
            unless data['type'].eql?('ping')
              @event_processor.process(data)
            end
          end

          ws.on :close do |event|
            p 'close worker'
            p [:close, event.code, event.reason]
            ws = nil
            @disconnected.make_true
            @started.make_false
            reconnect
          end
        }
      }
    end

    def reconnect
      return unless @disconnected.true? && @reconnect
      p 're-start worker'
      sleep RETRY_TIME_WAIT
      if @worker && @worker.alive? && @worker != Thread.current
        Thread.kill(@worker)
      end
      connect
    end

    private :connect, :reconnect

  end
end
