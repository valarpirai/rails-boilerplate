class PercentageFeatureSwitch < ApplicationRecord

  serialize :activity_data, Hash

  scope :history, lambda { |name|
    where(:name => name, :active => false).order(:created_at => :desc)
  }

  scope :active, lambda { where(:active => true) }

end
