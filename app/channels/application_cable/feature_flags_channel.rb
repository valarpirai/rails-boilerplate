module ApplicationCable
  class FeatureFlagsChannel < ActionCable::Channel::Base

    def subscribed
      stream_from 'messages'
    end
  end
end
