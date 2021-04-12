# Process all the flag related events and store them
module FlagManager
  class EventProcessor

    SUPPORTED_EVENTS = [:flag_enabled, :flag_disabled, :flag_deleted, :flag_added]

    def initialize
    end

    def process(event_data)
      puts event_data.inspect
    end

    def new_flag_added_event(data)
    end

    def flag_deleted_event
    end


  end
end