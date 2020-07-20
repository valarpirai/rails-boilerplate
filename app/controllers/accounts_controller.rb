# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :sanitize_params, :set_additional_signup_params, only: [:signup]
  def new; end

  def signup
    # Signup New account
    @signup = Signup.new(signup_params)
    # Signup Admin User
    if @signup.save
      respond_to do |format|
        format.html do
          render json: { success: true,
                         url: signup_complete_url(token: @signup.account.agents.first.user.perishable_token, host: @signup.account.full_domain),
                         account_id: @signup.account.id  },
                 callback: params[:callback]
        end
        format json
        format.nmobile do
          render json: { success: true, host: @signup.account.full_domain,
                         t: @signup.account.agents.first.user.single_access_token,
                         support_email: @signup.account.agents.first.user.email }
        end
      end
    else
      render json: { success: false, errors: (@signup.account.errors || @signup.errors).app_json }, callback: params[:callback]
    end
  end

  private

  def sanitize_params
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
    params.permit(:user, :account)
  end

  def set_additional_signup_params
    return if params.dig(:signup, :account_domain).present?
    domain_generator = SubDomainGenerator.new(params[:signup].slice(:user_email, :account_name))
    debugger
    if domain_generator.valid?
      params[:signup][:account_domain] = domain_generator.subdomain
    else
      render json: { success: false, errors: domain_generator.errors.app_json }, callback: params[:callback]
    end
  end
end
