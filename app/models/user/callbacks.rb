class User < ApplicationRecord
  before_validation :set_account_id

  def set_account_id
    debugger
    self.account_id ||= self.account.id
  end
end