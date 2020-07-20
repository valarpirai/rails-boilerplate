# Accoun Signup validation
class Validations::AccountSignup < Validations::Base

  attr_accessor :account, :user

  def initialize(params = {})
    @user  = params[:user]
    @account = params[:account]
    ActionController::Parameters.new(params).permit(:user, :account)
  end
end