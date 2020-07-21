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

    def reset_current
      Thread.current[:account] = nil
    end

    def fetch_by_full_domain(full_domain)
      return if full_domain.blank?
      find_by(full_domain: full_domain)
    end
  end
end
