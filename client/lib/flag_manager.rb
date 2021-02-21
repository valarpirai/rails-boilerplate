require 'concurrent-ruby'
require 'oj'
require 'flag_manager/base'
require 'flag_manager/config'
require 'flag_manager/event_processor'
require 'flag_manager/web_socket'

module FlagManager

    class << self
        def init
            url = 'ws://localhost.myapp-dev.com:3000/cable'
            api_key = 'rbx-12797d0f56657b89af45'
            processor = FlagManager::EventProcessor.new
            FlagManager::WebSocket.new(url, api_key, processor)
        end
    end
end

