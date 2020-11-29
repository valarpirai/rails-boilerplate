class FeatureFlag < ApplicationRecord
  belongs_to_account
  belongs_to :project, class_name: 'Project'

  serialize :variations, Hash

  # validates unique ness

end
