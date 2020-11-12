module Concerns::ApplicationConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_account
  end

  def set_current_account
    # begin
    current_account.make_current
    current_user.make_current if user_signed_in?
    # rescue ActiveRecord::RecordNotFound
    # end
  end

  def current_account
    @current_account ||= retrieve_current_account
  end

  def retrieve_current_account
    account = Account.fetch_by_full_domain(request_host)
    raise ActiveRecord::RecordNotFound unless account
    account
  end

  def request_host
    @request_host ||= request.host
  end

  def cname
    controller_name.singularize
  end

  def cname_params
    params[cname]
  end
end
