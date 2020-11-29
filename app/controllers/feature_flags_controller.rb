class FeatureFlagsController < ApplicationController

  before_action :load_object, only: %i[show edit update destroy]
  before_action :load_parent, only: %i[create]
  before_action :permit_params, only: %i[create update]

  def new
    @feature_flag = FeatureFlag.new
  end

  def create
    @feature_flag = @parent.feature_flags.build(params[:feature_flag])
    if @feature_flag.save
      respond_to do |format|
        format.html do
          redirect_to project_path(@parent)
        end
        format.html do
          render json: { status: :success, message: 'Feature flag created successfully' }, status: :ok
        end
      end
    else
      render json: { status: :failure, message: 'Something went wrong..' }, status: :intenal_server_error
    end
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
    @flag.deleted = true
    @flag.save
  end

  private

  def load_parent
    @parent = current_account.projects.find(params[:project_id])
  end

  def load_object
    load_parent
    @flag = @parent.feature_flags.find(params[:id]) if params[:id]
  end

  def permit_params
    params.require(:feature_flag).permit!
    params[:feature_flag].delete(:type)
  end
end