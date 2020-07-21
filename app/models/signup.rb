# frozen_string_literal: true

class Signup
  attr_accessor :account, :user, :errors

  def initialize(params)
    @errors = []
    self.account = Account.new(params[:account])
    account.make_current
    self.user = User.new(params[:user])
    user.password = SecureRandom.hex(10)
    user.account = account
  end

  def save
    # raise 'account invalid' unless account.valid?
    account.save!
    # raise 'user invalid' unless user.valid?
    user.save!
  rescue Exception => e
    @errors << e
    clean_up
    false
  end

  def errors
    return account.errors.app_json unless account.errors.messages.blank?
    return user.errors.app_json unless user.errors.messages.blank?
    @errors
  end

  def clean_up
    account.destroy if account.persisted?
    user.destroy if user.persisted?
  end
end
