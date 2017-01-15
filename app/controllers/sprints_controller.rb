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
          "updated-at" => s.updated_at,
        }
      }
    }

    render json: {data: @sprints}
  end

  # GET /sprints/1
  def show
    result = {
      data: create_data(@sprint),
      included: get_included([@sprint])
    }

    render json: result
  end

  def get_included(sprints)
    sprints.flat_map { |sprint|
      sprint.stories.map { |s|
        {
          id: s.id,
          type: "stories",
          attributes: {
            "story-no" => s.story_no,
            title: s.title,
            description: s.description
          }
        }
      }
    }
  end

  def create_data(sprint)
    data = {
      id: sprint.id,
      type: "sprint",
      attributes: {
        name: sprint.name,
        status: sprint.status,
        "created-at" => sprint.created_at,
        "updated-at" => sprint.updated_at
      },
      relationships: {
        stories: {
          data: @sprint.stories.map { |s| { type: "stories", id: s.id} }
        }
      }
    }
  end

  # POST /sprints
  def create
    # byebug
    @sprint = Sprint.new(sprint_params[:attributes])

    sprint_params[:relationships].each do |key, value|
      @sprint.send("#{key}_id=", value[:data ][:id])
    end

    if @sprint.save
      result = {
        data: create_data(@sprint),
        included: get_included([@sprint])
      }
      render json: result
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
      @sprint = Sprint.includes(:stories).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sprint_params
      params.require(:data).permit!
    end
end
