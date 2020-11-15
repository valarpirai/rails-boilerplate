class ProjectsController < ApplicationController
  before_action :permit_params, only: [:create, :update]
  before_action :load_object, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_account.projects.build(params[:project])
    if @project.save
    end
  end

  def show

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def load_object
    @project = current_account.projects.find(params[:id]) if params[:id]
  end

  def permit_params
    # params.require(:project).permit(project: %i[name description])
    params.require(:project).permit! #(:project, :name, :description)
  end
end
