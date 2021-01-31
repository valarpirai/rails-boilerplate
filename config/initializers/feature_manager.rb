# ARGS - URL, API Key, Global Store
# Store is initialized and passed to WS Listener. On Flag change it will be updated - Thread Safe
# The Store is directly accessed from the APP

$feature_manager = Concurrent::Map.new

Oj.optimize_rails()

# Note - Don't use return inside EventMachine and other blocks

def start_client(manager, url, api_key)
  channel_name = 'ApplicationCable::FeatureFlagsChannel'
  Thread.new {
    EventMachine.run {
      auth_token = Base64.encode64( "#{api_key}:x" ).chomp
      url = "#{url}?token=#{auth_token}"
      ws = Faye::WebSocket::Client.new(url)

      ws.on :open do |event|
        p [:open]
        # ws.send('Hello, world!')
        ws.send({"command":"subscribe","identifier":"{\"channel\":\"#{channel_name}\"}"}.to_json)
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)
        unless data['type'].eql?('ping')
          p data
        end
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
    }
  }
end

url = 'ws://localhost.myapp-dev.com:3001/cable'
api_key = 'rbx-ae6b7d4949a226e235fa'
start_client($feature_manager, url, api_key)
