class ProjectsController < ApplicationController
  before_action :permit_params, only: %i[create update]
  before_action :load_object, except: %i[index new create]
  before_action :load_environment, only: %i[show]

  def index
    @projects = Project.includes([:feature_flags, :environments]).page params[:page]
  end

  def new
    @project = Project.new
    render partial: 'new'
  end

  def create
    @project = current_account.projects.build(params[:project])
    # Create default environment
    @project.environments.push(Environment.new({ name: 'Production', description: '(default environment)', project: @project }))
    if @project.save
      respond_to do |format|
        format.html do
          redirect_to projects_path
        end
        format.html do
          render json: { status: :success, message: 'Project created successfully' }, status: :ok
        end
      end
    else
      flash[:messages] = @project.errors.full_messages.to_sentence
      redirect_to projects_path
    end
  end

  def show
    @feature_flags = @project.feature_flags.page params[:page]
    env_config = EnvironmentConfig.where(environment_id: @environment.id, feature_flag: @feature_flags.map(&:id))
    @configs = env_config.each_with_object({}) { |conf, obj| obj[conf.feature_flag_id] = conf }
  end

  def change_environment
    if @project.environments.where(name: params[:env]).exists?
      redirect_to project_path(@project.uuid, env: params[:env])
    else
      render :nothing => true, :status => :bad_request
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to projects_path
    else
      # throw error
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def load_object
    @project ||= current_account.projects.find_by(uuid: (params[:id] || params[:project_id])) if params[:id] || params[:project_id]
    raise ActiveRecord::RecordNotFound unless @project
    @project
  end

  def load_environment
    @environments ||= load_object.environments
    @environment ||= @environments.select { |env| env.name == params[:env] }.first || @environments.first
  end

  def permit_params
    # params.require(:project).permit(project: %i[name description])
    params.require(:project).permit! #(:project, :name, :description)
  end
end
