class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.includes(:sprints).all

    result = {
      data: @projects.map { |p| create_data(p) },
      included: get_included(@projects)
    }

    render json: result
  end

  def create_data(project)
    {
      id: project.id,
      type: "project",
      attributes: {
        name: project.name
      },
      relationships: {
        sprints: {
          data: project.sprints.map { |s| { id: s.id, type: 'sprint' } }
        }
      }
    }
  end

  def get_included(projects)
    projects.flat_map { |p|
      p.sprints.includes(:stories).map { |s|
        {
          id: s.id,
          type: "sprint",
          attributes: {
            name: s.name,
            status: s.status
          }
        }
      }
    }
  end

  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params[:attributes])

    project_params[:relationships].each do |key, value|
      @project.send("#{key}_id=", value[:data ][:id])
    end

    if @project.save
      result = {
        data: create_data(@project)
      }
      render json: result
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:data).permit!
    end
end
