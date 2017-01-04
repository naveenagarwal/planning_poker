class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :update, :destroy]

  # GET /sprints
  def index
    @sprints = Sprint.all.map { |s| {
        id: s.id,
        type: "sprint",
        attributes: {
          name: s.name,
          status: s.status,
          "project-id" => s.project_id,
          "created-at" => s.created_at,
          "updated-at" => s.updated_at
        }
      }
    }

    render json: {data: @sprints}
  end

  # GET /sprints/1
  def show
    data = {
      data: {
        id: @sprint.id,
        type: "sprint",
        attributes: {
          name: @sprint.name,
          status: @sprint.status,
          "project-id" => @sprint.project_id,
          "created-at" => @sprint.created_at,
          "updated-at" => @sprint.updated_at
        },
        relationships: {
          stories: {
            data: @sprint.stories.map { |s| { type: "stories", id: s.id} }
          }
        }
      },
      included: @sprint.stories.map { |s| { type: "stories", id: s.id, attributes: { title: s.title, description: s.description } } }
    }

    render json: data
  end

  # POST /sprints
  def create
    @sprint = Sprint.new(sprint_params)

    if @sprint.save
      render json: @sprint, status: :created, location: @sprint
    else
      render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sprints/1
  def update
    if @sprint.update(sprint_params)
      render json: @sprint
    else
      render json: @sprint.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sprints/1
  def destroy
    @sprint.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:sprint).permit(:name, :references)
    end
end
