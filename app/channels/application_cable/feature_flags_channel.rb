module ApplicationCable
  class FeatureFlagsChannel < Channel

    def subscribed
      # stream_from 'messages'
      stream_from "messages_#{current_environment.client_id}"
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end  
  end
end
