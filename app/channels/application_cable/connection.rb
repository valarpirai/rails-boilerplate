module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_environment

    def connect
      self.current_environment = find_verified_env
      logger.add_tags 'ActionCable', current_environment.name, current_environment.id
    end

    private
      def host
        @host ||= Rails.env.development? ? env["HTTP_HOST"].split(':')[0] : env["HTTP_HOST"]
      end

      def find_verified_env
        api_key = decode_auth_credentials
        verified_env = false
        # Verify Account domain and API key
        Sharding.select_shard_of(host) do
          verified_env = Environment.find_by(api_key: api_key)
        end

        if api_key.present? && verified_env
          return verified_env
        end
        reject_unauthorized_connection
      end

      def decode_auth_credentials
        http_auth_header = request.headers['HTTP_AUTHORIZATION'] || request.params['token']
        basic_auth_match = http_auth_header.present? ? /Basic (.*)/.match(http_auth_header) : nil
        api_key_with_x = Base64.decode64((basic_auth_match.blank? || basic_auth_match.length <= 1) ? http_auth_header : basic_auth_match[1])
        return api_key_with_x.split(":")[0]
     end
  end
end
