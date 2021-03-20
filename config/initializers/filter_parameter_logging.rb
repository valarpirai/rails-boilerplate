# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :password_confirmation, :crypted_password, 
                            :password_salt, :api_token, :client_id, :secret_key, :private_key_identifier, :private_key ]
