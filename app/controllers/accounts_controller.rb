# frozen_string_literal: true

class AccountsController < ApplicationController
  around_action :select_latest_shard, only: [:signup]
  before_action :validate_params
  before_action :build_signup_params, :set_additional_signup_params, only: [:signup]
  def new; end

  def signup
    # Signup New account
    @signup = Signup.new(signup_params)
    # Signup Admin User
    if @signup.save
      respond_to do |format|
        format.html do
          redirect_to edit_user_password_url(reset_password_token: @signup.account.users.first.generate_reset_password_token,
            host: @signup.account.full_domain)
        end
        format.json do
          render json: { success: true, host: @signup.account.full_domain,
                         t: @signup.account.first.user.generate_reset_password_token}
        end
      end
    else
      render json: { success: false, errors: (@signup.errors) }
    end
  end

  private

  def validate_params
  end

  def build_signup_params
    params[:signup] = {}
    %w[user account].each do |param|
      params[param].each do |key, value|
        key = "#{param}_#{key}".to_sym
        params[:signup][key] = value
      end
    end

    params[:signup][:locale] = 'en'
    params[:signup][:time_zone] = params[:utc_offset]
  end

  def signup_params
    params.permit(user: %i[first_name last_name email], account: %i[name full_domain])
  end

  def set_additional_signup_params
    return if params.dig(:signup, :account_domain).present?
    domain_generator = SubDomainGenerator.new(params[:signup].slice(:user_email, :account_name))
    unless domain_generator.valid?
      render json: { success: false, errors: domain_generator.errors.app_json }, callback: params[:callback]
    end
    params[:signup][:account_domain] = domain_generator.domain
    params['account']['full_domain'] = domain_generator.domain
  end
end
