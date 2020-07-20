# frozen_string_literal: true

class Signup
  attr_accessor :account, :user

  def initialize(params)
    self.account = Account.new(params[:account])
    self.user = User.new(params[:user])

    # Create object
  end

  def save
    return false unless account.save
    return false unless user.save
    true
  end
end
