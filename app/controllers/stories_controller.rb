class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /stories
  def index
    @stories = Story.all

    render json: @stories
  end

  # GET /stories/1
  def show
    data = {
      data: {
        id: @story.id,
        type: "story",
        attributes: {
          title: @story.title,
          description: @story.description,
          "story-no" => @story.story_no,
          "sprint-id" => @story.sprint_id,
          "estimated-points" => @story.estimated_points,
          "estimated-time" => @story.estimated_time,
          "created-at" => @story.created_at,
          "updated-at" => @story.updated_at
        },
        relationships: {
          "story-points" => {
            data: @story.story_points.map { |s| { type: "story-points", id: s.id} }
          },
          sprint: {
            data: { id: @story.sprint_id, type: "sprint" }
          }
        }
      },
      included: @story.story_points.map { |s|
        {
          type: "story-points",
          id: s.id,
          attributes: {
            "estimated-points" => s.estimated_points,
            "estimated-time" => s.estimated_time
          },
          relationships: {
            user: {
              data: { type: "user", id: s.user.id, attributes: { name: s.user.name, email: s.user.email } }
            }
          }
        }
      }
    }
    render json: data
  end

  # POST /stories
  def create
    @story = Story.new(story_params)

    if @story.save
      render json: @story, status: :created, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      render json: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      params.require(:story).permit(:story_no, :title, :description, :estimated_points, :estimated_time, :references)
    end
end
