class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :check_token, only: [:create]

  # GET /users
  def index
    single_record = params[:filter].delete(:single_record) == "true"
    users = User.includes(:organization, :story_points).where(id: params[:filter][:id]).all

    if single_record
      user = users.first
      data = create_data(user)
      result = { data: data }
      result[:included] = get_included(user)
    else
      data = users.map { |u| create_data(u) }
      result = { data: data }
      result[:included] = users.flat_map { |u| get_included(u) }
    end


    render json: result
  end

  def get_included(user)
    if params[:filter]
      story_points = user.story_points.where(sprint_id: params[:filter][:sprint_id]).map { |s|
        {
          type: "story-points",
          id: s.id,
          attributes: {
            "estimated-points" => s.estimated_points,
            "estimated-time" => s.estimated_time
          }
        }
      }
    else
      story_points = []
    end

    organization = user.organization
    organization = {
      type: "organization",
      id: organization.id,
      attributes: {
        name: organization.name,
        website: organization.website
      }
    }
    story_points << organization
  end

  def create_data(user)
    data = {
      id: user.id,
      type: "user",
      attributes: {
        name: user.name,
        email: user.email,
        role: user.role,
        "created-at" => user.created_at,
        "updated-at" => user.updated_at
      }
    }

    data.merge!({
      relationships: {
        "story-points" => {
          data: user.story_points.map { |s| { id: s.id, type: "story-points" }  }
        },
        organization: {
          data: { id: user.organization.id, type: "organization" }
        }
      }
    })

    data
  end

  # GET /users/1
  def show
    data = {
      data: {
        id: @user.id,
        type: "user",
        attributes: {
          name: @user.name,
          email: @user.email,
          role: @user.role,
          "created-at" => @user.created_at,
          "updated-at" => @user.updated_at
        },
        relationships: {
          "story-points" => {
            data: @user.story_points.map { |s| { id: s.id, type: "story-points" }  }
          }
        }
      },
      included: @user.story_points.map { |s|
        {
          type: "story-points",
          id: s.id,
          attributes: {
            "estimated-points" => s.estimated_points,
            "estimated-time" => s.estimated_time
          }
        }
      }
    }
    render json: data
  end

  # POST /users
  def create
    @user = User.new(user_params[:attributes])

    @user.organization = Organization.first
    @user.role = "participant"

    if @user.save
      result = {
        data: create_data(@user),
        included: get_included(@user)
      }
      render json: result
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT
  def add_credentials
    result = {}
    params.require(:jira).permit!
    user = User.find(params[:id])
    if user.update(params[:jira])
      result[:success] = true
    else
      result[:success] = false
    end
    render json: result
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:data).permit!
    end
end
