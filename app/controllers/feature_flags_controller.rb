class FeatureFlagsController < ApplicationController

  before_action :load_object, only: %i[show edit update destroy]
  before_action :load_parent, only: %i[create]
  before_action :permit_params, only: %i[create update]

  def new
    @feature_flag = FeatureFlag.new
    render partial: 'new'
  end

  def create
    feature_flag = @parent.feature_flags.new(params[:feature_flag])
    if feature_flag.save
      redirect_to_back project_path(@parent.uuid)
    else
      flash[:title] = 'Create Flag error'
      flash[:messages] = feature_flag.errors.full_messages.to_sentence
      redirect_to_back project_path(@parent.uuid)
    end
  end

  def edit
    render partial: 'edit'
  end

  def show
    render partial: 'show'
  end

  def update
    # Update Flag properties
  end

  def update_properties
  end

  def destroy
    @feature_flag.deleted = true
    @feature_flag.save
    # Redirect to current path
    redirect_to_back project_path(@parent.uuid)
  end

  private

  def load_parent
    @parent = current_account.projects.find_by(uuid: params[:project_id])
    raise ActiveRecord::RecordNotFound unless @parent
    @parent
  end

  def load_object
    load_parent
    @feature_flag = @parent.feature_flags.find(params[:id]) if params[:id]
  end

  def permit_params
    params.require(:feature_flag).permit!
    params[:feature_flag].delete(:type)
  end
end