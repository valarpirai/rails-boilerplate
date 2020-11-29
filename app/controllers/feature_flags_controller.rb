class FeatureFlagsController < ApplicationController

  before_action :load_object, only: %i[show edit update destroy]

  def new
    @Feature_flag = FeatureFlag.new
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

  def load_object
    @parent = current_account.projects.find(params[:project_id])
    @flag = @parent.feature_flags.find(params[:id]) if params[:id]
  end
end