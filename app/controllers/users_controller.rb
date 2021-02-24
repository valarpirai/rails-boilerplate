class UsersController < ApplicationController
  before_action :load_object, except: %i[index new create]

  def index
    @users = User.page params[:page]
  end

  def show
    render partial: 'show'
  end

  private
  def load_object
    @user ||= current_account.users.find((params[:id] || params[:user_id])) if params[:id] || params[:user_id]
    raise ActiveRecord::RecordNotFound unless @user
    @user
  end
end
