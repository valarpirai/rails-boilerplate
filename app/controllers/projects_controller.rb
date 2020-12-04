class ProjectsController < ApplicationController
  before_action :permit_params, only: %i[create update]
  before_action :permit_env_params, only: %i[create_environment]
  before_action :load_object, only: %i[show edit update destroy create_environment change_environment]
  before_action :load_environment, only: %i[show]

  def index
    @projects = Project.includes([:feature_flags, :environments]).page params[:page]
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_account.projects.build(params[:project])
    # Create default environment
    @project.environments.push(Environment.new({ name: 'Production', description: '(default environment)' }))
    if @project.save
      respond_to do |format|
        format.html do
          redirect_to projects_path
        end
        format.html do
          render json: { status: :success, message: 'Project created successfully' }, status: :ok
        end
      end
    end
  end

  def show
    @feature_flags = @project.feature_flags.page params[:page]
  end

  def create_environment
    env = @project.environments.new(params[:environment])
    if env.save
      redirect_to project_path(@project.uuid)
    else
    end
  end

  def change_environment
    if @project.environments.where(id: params[:env_id]).exists?
      session[:env] = params[:env_id].to_i
      redirect_to project_path(@project.uuid)
    else
      render :nothing => true, :status => :bad_request
    end
  end

  def edit
  end

  def update
    @project.update_attributes(params[:project])
    if @project.save
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
    @project ||= current_account.projects.find_by(uuid: params[:id]) if params[:id]
  end

  def load_environment
    @environments ||= load_object.environments
    @environment ||= @environments.select { |env| env.id == session[:env] }.first || @environments.first
    session[:env] = @environment.id
  end

  def permit_params
    # params.require(:project).permit(project: %i[name description])
    params.require(:project).permit! #(:project, :name, :description)
  end

  def permit_env_params
    params.require(:environment).permit!
  end
end
