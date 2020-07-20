# frozen_string_literal: true

class SubDomainGenerator
  require 'freemail'
  DOMAIN_SUGGESTION_KEYWORDS = [''].freeze
  APP_BASE_DOMAIN = AppConfig['base_domain'][Rails.env]

  include ActiveModel::Validations

  attr_accessor :email, :company_name

  validates_presence_of :email, :company_name
  validate :email_validity
  DOMAIN_REGEX = /[^a-zA-Z0-9-]/

  def initialize(params)
    self.email = Mail::Address.new(params[:user_email])
    self.company_name = begin
        params[:account_name].try(:gsub, DOMAIN_REGEX, '').slice(0..25).downcase
      rescue StandardError
        nil
      end
  end

  def domain
    @domain ||= generate_application_url
    @domain = generate_application_url random_digits if @domain.blank?
    @domain
  end

  def subdomain
    @subdomain ||= domain.gsub(".#{APP_BASE_DOMAIN}", '')
  end

  private

  def email_domain_name
    Freemail.free?(email_address) || Freemail.disposable?(email_address) ? nil : email.domain.split('.').first
  end

  def email_name
    @email_name ||= (email.display_name.try(:downcase) || email.local)
  end

  def run_domain_validations(account)
    Account.validators_on(:domain).each do |validator|
      validator.validate_each(account, :domain, account.domain)
      return false if account.errors[:domain].present?
    end
    return false if account.full_domain.split('.').count > 3
    true
  end

  def valid_domain?(full_domain)
    sample_account = Account.new
    sample_account.full_domain = full_domain
    valid = (DomainMapping.new(domain: full_domain, account: sample_account).valid? &&
    run_domain_validations(sample_account))
    valid
  end

  def generate_application_url(random = '')
    suggestions = [company_name, email_domain_name, email_name].compact
    suggestions.each do |sugg|
      DOMAIN_SUGGESTION_KEYWORDS.each do |keyword|
        domain_name = "#{sugg}#{keyword}#{random}.#{APP_BASE_DOMAIN}"
        return domain_name if valid_domain?(domain_name)
      end
    end
    nil
  end

  def random_digits
    SecureRandom.random_number.to_s[2..4]
  end

  def email_address
    email.address
  end

  def email_validity
    unless email_address.match?(Regex::EMAIL_VALIDATOR)
      errors.add(:email, I18n.t('activerecord.errors.messages.email_invalid'))
    end
  end
end
