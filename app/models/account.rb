# frozen_string_literal: true

class Account < ApplicationRecord
  validates_uniqueness_of :full_domain

  concerned_with :callbacks, :associations

  def domain
    @domain ||= full_domain.blank? ? '' : full_domain.split('.').first
  end

  def make_current
    RequestStore[:account] = self
  end

  class << self
    def current
      RequestStore[:account]
    end

    def reset_current
      RequestStore[:account] = nil
    end

    alias_method :reset_current_account, :reset_current

    def fetch_by_full_domain(full_domain)
      return if full_domain.blank?
      find_by(full_domain: full_domain)
    end
  end
end
