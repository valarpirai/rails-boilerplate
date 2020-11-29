class Project < ApplicationRecord
  belongs_to_account
  before_create :set_uuid

  has_many :feature_flags, class_name: 'FeatureFlag'

  private

  def set_uuid
    self.uuid = random_uuid
  end
end
