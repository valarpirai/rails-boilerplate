# frozen_string_literal: true

class DomainMapping < ApplicationRecord
  validates_uniqueness_of :domain

  belongs_to :account
end
