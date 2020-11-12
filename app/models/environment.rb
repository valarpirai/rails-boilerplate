class Environment < ApplicationRecord

  belongs_to_account

  belongs_to :project, class_name: 'Project'

end