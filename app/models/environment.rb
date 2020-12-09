class Environment < ApplicationRecord

  belongs_to_account

  belongs_to :project, class_name: 'Project'
  has_many :environment_configs, class_name: 'EnvironmentConfig', dependent: :destroy

  before_create :set_client_id

  private
  def set_client_id
    self.client_id = SecureRandom.hex(7)
    self.api_key = "rbx-#{SecureRandom.hex(10)}"
  end
end
