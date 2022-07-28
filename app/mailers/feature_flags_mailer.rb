class FeatureFlagsMailer < ApplicationMailer

  default from:     -> { common_address }

  def flag_updated
    @env_config = params[:env_config]
    mail(to: 'hello-myapp@mailsac.com', subject: 'Welcome to My Awesome Site')
  end

  private
  def common_address
    "notifications@#{Account.current.full_domain}"
  end
end
