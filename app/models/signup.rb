# frozen_string_literal: true

class Signup
  attr_accessor :account, :user, :errors

  def initialize(params)
    @errors = []
    set_full_domain(params[:account])
    self.account = Account.new(params[:account])
    account.make_current
    self.user = User.new(params[:user])
    user.password = SecureRandom.hex(10) if user.password.nil?
    user.account = account
  end

  def save
    # raise 'account invalid' unless account.valid?
    account.save!
    # raise 'user invalid' unless user.valid?
    user.save!
  rescue StandardError => e
    @errors << e
    clean_up
    false
  end

  def errors
    return account.errors.app_json unless account.errors.messages.blank?
    return user.errors.app_json unless user.errors.messages.blank?
    @errors
  end

  private

  def set_full_domain(account)
    account[:full_domain] = "#{account[:domain]}.#{SubDomainGenerator::APP_BASE_DOMAIN}" unless account[:full_domain]
    account.delete(:domain)
  end

  def clean_up
    account.destroy if account.persisted?
    user.destroy if user.persisted?
  end
end
