class ProjectsController < ApplicationController
  before_action :permit_params, only: %i[create update]
  before_action :load_object, only: %i[show edit update destroy]

  def index
    @projects = Project.includes(:feature_flags).page params[:page]
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_account.projects.build(params[:project])
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
    @project = current_account.projects.find_by(uuid: params[:id]) if params[:id]
  end

  def permit_params
    # params.require(:project).permit(project: %i[name description])
    params.require(:project).permit! #(:project, :name, :description)
  end
end
