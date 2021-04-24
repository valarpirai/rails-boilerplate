class Account < ApplicationRecord
  before_create :set_default_values, :populate_features

  protected

  def set_default_values
    self.time_zone = Time.zone.name if time_zone.nil?
    self.uuid = random_uuid
  end

  def populate_features
    # self.feature
    # Add default features
    # Plan based features etc
    # Add on features
  end
end
