class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    relationships = params[:filter].delete(:relationships) == "true"
    single_record = params[:filter].delete(:single_record) == "true"
    users = User.where(id: params[:filter][:id]).all

    if single_record
      user = users.first
      data = create_data(user, relationships)
      result = { data: data }

      if relationships
        result[:included] = get_included(user)
      end
    else
      data = users.map { |u| create_data(u, false) }
    end


    render json: result
  end

  def get_included(user)
    user.story_points.where(sprint_id: params[:filter][:sprint_id]).map { |s|
      {
        type: "story-points",
        id: s.id,
        attributes: {
          "estimated-points" => s.estimated_points,
          "estimated-time" => s.estimated_time
        }
      }
    }
  end

  def create_data(user, relationships)
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

    if relationships
      data.merge!({
        relationships: {
          "story-points" => {
            data: user.story_points.map { |s| { id: s.id, type: "story-points" }  }
          }
        }
      })
    end
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
          role: user.role,
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
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
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
      params.require(:user).permit(:name, :email, :organziation_id)
    end
end
