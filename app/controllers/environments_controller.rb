class EnvironmentsController < ApplicationController
  before_action :load_object, except: %i[new]
  before_action :load_parent, only: [:new]
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

  def enable_flag
    env_config = @environment.environment_configs.where(feature_flag_id: params[:flag_id]).first
    env_config = @environment.environment_configs.build(feature_flag_id: params[:flag_id]) unless env_config

    env_config.configs[:state] = :on
    env_config.save
  end

  def disable_flag
    env_config = @environment.environment_configs.where(feature_flag_id: params[:flag_id]).first
    env_config = @environment.environment_configs.build(feature_flag_id: params[:flag_id]) unless env_config

    env_config.configs[:state] = :off
    env_config.save
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
    @environment ||= @project.environments.find(params[:id] || params[:environment_id]) if params[:id] || params[:environment_id]
  end

  def permit_params
    params.require(:environment).permit!
  end
end
