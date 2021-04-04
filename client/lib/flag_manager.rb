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
            api_key = 'rbx-dc20af6ff7b29ce0f5d6'
            processor = FlagManager::EventProcessor.new
            FlagManager::WebSocket.new(url, api_key, processor)
        end
    end
end

