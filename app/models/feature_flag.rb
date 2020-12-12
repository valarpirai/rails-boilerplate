class FeatureFlag < ApplicationRecord
  attr_accessor :type, :choices, :default_choices

  belongs_to_account
  belongs_to :project, class_name: 'Project'
  has_many :environment_configs, class_name: 'EnvironmentConfig', dependent: :destroy

  validate :unique_name?
  validate :key_validity

  serialize :configs, Hash
  before_update :set_deleted_at, if: :deleted?

  default_scope do
    where(deleted: false)
  end

  VARIATION_TYPES = [
    [1, :boolean, "Boolean"],
    [2, :string, "String"],
    [3, :Number, "Number"],
    [4, :JSON, "JSON"],
  ].freeze

  VARIATION_TYPES_FOR_SELECT = Hash[VARIATION_TYPES.map { |info| [info[2], info[0]] }]

  KEY_REGEX = /^[A-Za-z0-9\-_]*$/


  def choices
    self.configs[:choices]
  end

  def choices=(value)
    self.configs[:choices] = value
  end

  def type
    self.configs[:type].to_i
  end

  def type=(value)
    self.configs[:type] = value
  end

  def default_choices
    self.configs[:default]
  end

  def default_choices=(value)
    self.configs[:default] = value
  end

  def variation(mode = :on)
    val = choices[default_choices[mode].to_i]
    if 1 == type
      val.downcase.eql?('true')
    elsif 3 == type
      val.to_i
    else
      val
    end
  end

  # def 
  #   obj.downcase == "true"
  # end

  private

  def set_deleted_at
    self.deleted_at = Time.now.utc
  end

  def deleted?
    self.changes.has_key?(:deleted)
  end

  def unique_name?
    errors.add(:name, " must be present") and return unless self.name
    conditions = ["name = '#{self.name}'"]
    conditions << " and id <> #{self.id}" unless new_record?
    errors.add(:name, " must be unique") if project.feature_flags.where(conditions.join).exists?
  end

  def key_validity
    errors.add(:base, "Feature Key Validation Failed") if key.nil? || key.match(KEY_REGEX).nil?
  end
end
