class StoryPointsController < ApplicationController
  before_action :set_story_point, only: [:show, :update, :destroy]

  # GET /story_points
  def index
    @story_points = StoryPoint.all

    render json: @story_points
  end

  # GET /story_points/1
  def show
    render json: @story_point
  end

  # POST /story_points
  def create
    # byebug
    # data = JSON.parse(JSON.parse(request.body.to_json).first)

    @story_point = StoryPoint.new(story_point_params[:attributes])
    story_point_params[:relationships].each do |key, value|
      @story_point.send("#{key}_id=", value[:data ][:id])
    end

    if @story_point.save
      data = {
        data: {
          id: @story_point.id,
          type: "story-point",
          attributes: {
            "estimated-points" => @story_point.estimated_points,
            "estimated-time" => @story_point.estimated_time
          }
        }
      }
      # render json: @story_point, status: :created, location: @story_point
      render json: data
    else
      render json: @story_point.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /story_points/1
  def update
    if @story_point.update(story_point_params)
      render json: @story_point
    else
      render json: @story_point.errors, status: :unprocessable_entity
    end
  end

  # DELETE /story_points/1
  def destroy
    @story_point.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_point
      @story_point = StoryPoint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_point_params
      # params.require(:story_point).permit(:user_id, :story_id, :estimated_points, :estimated_time)
      params.require(:data).permit!
    end
end
