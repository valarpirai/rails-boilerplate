class Account < ApplicationRecord
    before_create :set_default_values

    protected
        def set_default_values
            self.time_zone = Time.zone.name if time_zone.nil?
            self.uuid = GUID.next
        end
end