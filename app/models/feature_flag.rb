class FeatureFlag < ApplicationRecord
  belongs_to_account
  belongs_to :project, class_name: 'Project'

  attr_accessor :type, :choices, :default_choices

  VARIATION_TYPES = [
    [1, :boolean, "Boolean"],
    [2, :string, "String"],
    [3, :Number, "Number"],
    [4, :JSON, "JSON"],
  ].freeze

  VARIATION_TYPES_FOR_SELECT = Hash[VARIATION_TYPES.map { |info| [info[2], info[0]] }]

  KEY_REGEX = /^[A-Za-z0-9\-_]*$/

  validate :unique_name?
  validate :key_validity

  serialize :variations, Hash

  before_update :set_deleted_at, if: :deleted?

  default_scope do
    where(deleted: false)
  end

  def choices
    return '' unless self.variations[:choices]
    self.variations[:choices].join(', ')
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
