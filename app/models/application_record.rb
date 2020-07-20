# encoding: utf-8
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.primary_key = :id

  def account
    ::Account.current || super
  end

  class << self
    # Tenent configurations
    def belongs_to_account
      belongs_to :account, class_name: '::Account'
      default_scope do
        where(account_id: ::Account.current.id) unless ::Account.current.blank?
      end
    end

    def concerned_with(*concerns)
      concerns.each do |concern|
        require_dependency "#{name.underscore}/#{concern}"
      end
    end
  end
end
