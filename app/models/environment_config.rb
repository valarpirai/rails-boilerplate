class EnvironmentConfig < ApplicationRecord

  STATE = [[:on, 'on', 1], [:off, 'off', 2], [:partial, 'partial', 3]].freeze

  STATE_BY_KEY = Hash[STATE.map { |i| [i[0], i[1]] } ]
  STATE_BY_ID = Hash[STATE.map { |i| [i[2], i[1]] } ]

  belongs_to_account

  belongs_to :environment, class_name: 'Environment'
  belongs_to :feature_flag, class_name: 'FeatureFlag'

  serialize :configs, Hash

end
