class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /stories
  def index
    stories = Story.includes(:story_points).where(sprint_id: params[:filter][:sprint_id]).all
    result = {
      data: stories.map { |s| create_data(s) }
      # included: get_included(stories)
    }
    render json: result
  end

  def create_data(story)
    {
      id: story.id,
      type: "story",
      attributes: {
        title: story.title,
        description: story.description,
        "story-no" => story.story_no,
        "reveal-points" => story.reveal_points,
        "sprint-id" => story.sprint_id,
        "estimated-points" => story.estimated_points,
        "estimated-time" => story.estimated_time,
        "created-at" => story.created_at,
        "updated-at" => story.updated_at
      },
      relationships: {
        "story-points" => {
          data: story.story_points.map { |s| { type: "story-points", id: s.id} }
        },
        sprint: {
          data: { id: story.sprint_id, type: "sprint" }
        }
      }
    }
  end

  def get_included(stories)
    stories.flat_map do |story|
      story.story_points.map { |s|
        {
          type: "story-points",
          id: s.id,
          attributes: {
            "estimated-points" => s.estimated_points,
            "estimated-time" => s.estimated_time,
            "user-id" => s.user_id
          },
          relationships: {
            user: {
              data: { type: "user", id: s.user.id }
            }
          }
        }
      }
    end
  end

  # GET /stories/1
  def show
    result = {
      data: create_data(@story),
      included: get_included([@story])
    }

    render json: result
  end

  # POST /stories
  def create
    @story = Story.new(story_params[:attributes])

    story_params[:relationships].each do |key, value|
      @story.send("#{key}_id=", value[:data ][:id])
    end

    if @story.save
      result = {
        data: create_data(@story),
        included: get_included([@story])
      }
      render json: result
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params[:attributes])
      result = {
        data: create_data(@story),
        included: get_included([@story])
      }
      render json: result
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
      @story = Story.includes(story_points: :user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      # params.require(:story).permit(:story_no, :title, :description, :estimated_points, :estimated_time, :references)
      params.require(:data).permit!
    end
end
