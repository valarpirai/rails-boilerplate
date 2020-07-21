module Concerns::ApplicationConcern
  extend ActiveSupport::Concern

  def set_current_account
    # begin
      current_account
      # User.current = current_user
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
end