# encoding: utf-8
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.primary_key = :id
end
