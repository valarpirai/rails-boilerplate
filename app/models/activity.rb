# Activities
class Activity < ApplicationRecord
  belongs_to_account
  belongs_to :notable, polymorphic: true

  serialize :activity_data

  validates_presence_of :description, :notable_id, :user_id

  scope :activity_since, lambda { |id|
    where(['activities.id > ? ', id]).order('activities.id DESC')
  }
  scope :activity_before, lambda { | activity_id|
    where(['activities.id <= ?', activity_id]).order('activities.id DESC')
  }
  scope :newest_first, -> { order('activities.account_id, activities.id DESC') }
end
