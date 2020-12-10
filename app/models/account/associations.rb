# frozen_string_literal: true

# Assocations for Account
class Account < ApplicationRecord
  has_many :users, lambda {
    where(['deleted = false']).order(first_name: :asc, last_name: :asc)
  }, class_name: 'User'

  has_many :projects, class_name: 'Project', inverse_of: :account
  has_many :feature_flags, class_name: 'FeatureFlag', inverse_of: :account
  has_many :environments, class_name: 'Environment', inverse_of: :account
  has_many :activities, class_name: 'Activity', inverse_of: :account
end
