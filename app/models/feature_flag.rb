class FeatureFlag < ApplicationRecord
  belongs_to_account
  belongs_to :project, class_name: 'Project'

  validates_uniqueness_of :name

  serialize :variations, Hash

  before_update :set_deleted_at, if: :deleted?

  default_scope do
    where(deleted: false)
  end


  private

  def set_deleted_at
    self.deleted_at = Time.now.utc
  end

  def deleted?
    self.changes.has_key?(:deleted)
  end

end
