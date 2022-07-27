module Concerns::ApplicationConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_account
  end

  def set_current_account
    # begin
    current_account.make_current
    # current_user.make_current if user_signed_in?
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

  def redirect_to_back(default = root_url)
    if request.env['HTTP_REFERER'].present? and request.env['HTTP_REFERER'] != request.env['REQUEST_URI']
      redirect_to request.env['HTTP_REFERER']
    else
      redirect_to default
    end
  end

  def select_latest_shard(&block)
    Sharding.select_latest_shard(&block)
  end

  private

  def append_info_to_payload(payload)
    super
    payload[:domain] = request.env['HTTP_HOST']
    payload[:ip] = Thread.current[:client_ip] = request.env['REMOTE_ADDR']
    payload[:url] = request.url
    payload[:account_id] = Account.current ? Account.current.id : ""
    payload[:user_id]    = (Account.current && User.current) ? User.current.id : ""
    payload[:shard_name] = Thread.current[:shard_name_payload]
    payload[:uuid] = Thread.current[:message_uuid] = request.request_id
    payload[:sip] = request.env['SERVER_NAME']
  end
end
