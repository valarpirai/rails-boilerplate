class EnvironmentsController < ApplicationController
  before_action :load_object, only: %i[show edit update destroy edit_properties]
  before_action :load_parent
  before_action :permit_params, only: %i[create]

  def new
    render partial: 'new'
  end

  def create
    env = @project.environments.new(params[:environment])
    if env.save
      redirect_to_back project_path(@project.uuid)
    else
      flash[:messages] = env.errors.full_messages.to_sentence
      redirect_to_back project_path(@project.uuid)
    end
  end

  def destroy
    @project.environments.find_by(name: params[:env]).destroy
    redirect_to project_path(@project.uuid)
  end

  private

  def load_parent
    @project ||= current_account.projects.find_by(uuid: params[:project_id])
    raise ActiveRecord::RecordNotFound unless @project
    @project
  end

  def load_object
    load_parent
    @environment ||= @project.environments.find(params[:id]) if params[:id]
  end

  def permit_params
    params.require(:environment).permit!
  end
end
