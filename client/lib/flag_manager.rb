require 'concurrent-ruby'
require 'oj'
require 'flag_manager/base'
require 'flag_manager/config'
require 'flag_manager/event_processor'
require 'flag_manager/web_socket'

module FlagManager
    @connector = nil
    class << self
        def init(domain, options = {})
            return @connector if @connector
            url = "ws://#{ domain || 'localhost.myapp-dev.com:3000' }/cable"
            api_key = options[:api_key] || 'rbx-dc20af6ff7b29ce0f5d6'
            processor = EventProcessor.new

            options[:method]
            @connector = WebSocket.new(url, api_key, processor)
        end

        def flag_enabled(flag_name, account)
            # Check flag is enabled for current account
            # Push usage metrics
        end

        # Provide standalone APIs and storage
        # Support FlagManager web APIs
        def enable! flag_name
        end

        def enable_actor! flag_name, account
        end

        def enable_percentage_of_actors flag_name, percentage = 1
        end
    end
end

