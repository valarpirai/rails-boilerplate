class EnvironmentConfig < ApplicationRecord

  belongs_to_account

  belongs_to :environment, class_name: 'Environment'
  belongs_to :feature_flag, class_name: 'FeatureFlag'

  serialize :configs, Hash

end
