module FlagManager
    class Config
        PROTOCOL = 'ws'
        SECURE_PROTOCOL = 'wss'
        WS_ENDPOINT = '/cable'

        # WEB_SOCKET_URL = "#{PROTOCOL}://#{URL}#{WS_ENDPOINT}".freeze
        # SECURE_WEB_SOCKET_URL = "#{SECURE_PROTOCOL}://#{FlagManager_URL}#{WS_ENDPOINT}".freeze

        CHANNEL = 'ApplicationCable::FeatureFlagsChannel'.freeze
        SUBSCRIBE_COMMAND = Oj.dump({ 'command' => 'subscribe', 'identifier' => Oj.dump({ 'channel' => CHANNEL }) }).freeze
    end
end
