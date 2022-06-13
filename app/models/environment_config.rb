class EnvironmentConfig < ApplicationRecord

  STATE = [[:on, 'on', 1], [:off, 'off', 2], [:partial, 'partial', 3]].freeze

  STATE_BY_KEY = Hash[STATE.map { |i| [i[0], i[1]] } ]
  STATE_BY_ID = Hash[STATE.map { |i| [i[2], i[1]] } ]

  belongs_to_account

  belongs_to :environment, class_name: 'Environment'
  belongs_to :feature_flag, class_name: 'FeatureFlag'

  serialize :configs, Hash

  before_validation :set_parent_ids

  # validates :config_data


  def config_data
  end

  def set_parent_ids
    self.feature_flag_id ||= feature_flag.id if feature_flag_id.nil? && !feature_flag.nil?
    self.environment_id ||= environment.id if environment_id.nil? && !environment.nil?
  end
end
