class FeatureFlag < ApplicationRecord
  belongs_to_account
  belongs_to :project, class_name: 'Project'

  attr_accessor :choices

  KEY_REGEX = /^[A-Za-z0-9\-_]*$/

  validate :unique_name?
  validate :key_validity

  serialize :variations, Array

  before_update :set_deleted_at, if: :deleted?

  default_scope do
    where(deleted: false)
  end

  def choices
    self.variations.join(', ')
  end

  def choices=(value)
    self.variations = value.split(',').map(&:strip).uniq
  end

  private

  def set_deleted_at
    self.deleted_at = Time.now.utc
  end

  def deleted?
    self.changes.has_key?(:deleted)
  end

  def unique_name?
    conditions = ["name = '#{self.name}'"]
    conditions << " and id <> #{self.id}" unless new_record?
    errors.add(:name, " must be unique") if project.feature_flags.where(conditions.join).exists?
  end

  def key_validity
    errors.add(:base, "Feature Key Validation Failed") if key.match(KEY_REGEX).nil?
  end
end
