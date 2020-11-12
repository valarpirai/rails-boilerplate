class Project < ApplicationRecord
  belongs_to_account
  before_create :set_uuid

  private

  def set_uuid
    self.uuid = random_uuid
  end
end
