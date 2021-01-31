module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_environment

    def connect
      self.current_environment = find_verified_env
      logger.add_tags 'ActionCable', current_environment.name, current_environment.id
    end

    private
      def find_verified_env
        # TODO - Verify Account domain and API key
        api_key_split = decode_auth_credentials
        if api_key_split.present? && verified_env = Environment.find_by(api_key: api_key_split[0])
          return verified_env
        end
        reject_unauthorized_connection
      end

      def decode_auth_credentials
        http_auth_header = request.headers['HTTP_AUTHORIZATION'] || request.params['token']
        # puts request.headers.env.reject { |key| key.to_s.include?('.') }.inspect
        puts 'http_auth_header'
        puts http_auth_header.inspect
        basic_auth_match = http_auth_header.present? ? /Basic (.*)/.match(http_auth_header) : nil
        if basic_auth_match.blank? || basic_auth_match.length <= 1
          api_key_with_x = Base64.decode64(http_auth_header)
          return api_key_with_x.split(":")
        else
          api_key_with_x = Base64.decode64(basic_auth_match[1])
          return api_key_with_x.split(":")
        end
     end
  end
end
