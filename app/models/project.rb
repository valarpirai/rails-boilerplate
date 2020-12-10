class Project < ApplicationRecord
  belongs_to_account
  before_create :set_uuid

  validate :unique_name?

  has_many :feature_flags, class_name: 'FeatureFlag', dependent: :destroy
  has_many :environments, class_name: 'Environment', dependent: :destroy

  private

  def set_uuid
    self.uuid = random_uuid
  end

  def unique_name?
    errors.add(:name, " must be unique") if account.projects.where(name: self.name).exists?
  end
end
