class User < ApplicationRecord
  validates :account_id, :first_name, presence: true
end
