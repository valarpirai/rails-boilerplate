class ProjectsController < ApplicationController
  before_action :permit_params, only: [:create, :update]

  def index
    @projects = Project.all
  end

  def show; end

  def new
    @project = Project.new
  end

  def create
    @project = current_account.projects.build(params[:project])
    @project.save
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def permit_params
    # params.require(:project).permit(project: %i[name description])
    params.require(:project).permit! #(:project, :name, :description)
  end
end
