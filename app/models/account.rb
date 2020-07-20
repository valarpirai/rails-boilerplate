# frozen_string_literal: true

class Account < ApplicationRecord
  validates_uniqueness_of :full_domain, :uuid

  concerned_with :callbacks

  has_many :users, lambda {
    where(['deleted = false']).order(first_name: :asc, last_name: :asc)
  }, class_name: 'User'

  def domain
    @domain ||= full_domain.blank? ? '' : full_domain.split('.').first
  end

  def make_current
    Thread.current[:account] = self
  end

  class << self
    def current
      Thread.current[:account]
    end
  end
end
