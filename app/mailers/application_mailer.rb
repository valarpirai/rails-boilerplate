class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@myapp.com'
  layout 'mailer'

  before_action { @account_id = params[:account_id] }
  around_action :select_shard

  def select_shard(&block)
    Sharding.select_shard_of(params[:account_id]) do
      Account.find_by(id: params[:account_id]).make_current
      yield
      Account.reset_current_account
    end
  end

end
