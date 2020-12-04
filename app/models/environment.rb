class Environment < ApplicationRecord

  belongs_to_account

  belongs_to :project, class_name: 'Project'
  has_many :environment_configs, class_name: 'EnvironmentConfig', dependent: :destroy

  validates_uniqueness_of :name

end
