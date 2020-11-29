class Project < ApplicationRecord
  belongs_to_account
  before_create :set_uuid

  has_many :feature_flags, class_name: 'FeatureFlag', dependent: :destroy
  has_many :environments, class_name: 'Environment', dependent: :destroy

  private

  def set_uuid
    self.uuid = random_uuid
  end
end
