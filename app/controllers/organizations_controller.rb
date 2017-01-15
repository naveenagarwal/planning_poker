class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :update, :destroy]

  # GET /organizations
  def index
    @organizations = Organization.all

    render json: @organizations
  end

  # GET /organizations/1
  def show
    result = {
      data: create_data(@organization),
      included: get_included(@organization)
    }
    render json: result
  end

  def get_included(org)
    org.projects.map { |p|
      {
        type: "projects",
        id: p.id,
        attributes: {
          name => p.name
        }
      }
    }
  end

  def create_data(org)
    data = {
      id: org.id,
      type: "organization",
      attributes: {
        name: org.name,
        email: org.website
      }
    }

    data.merge!({
      relationships: {
        "projects" => {
          data: org.projects.map { |p| { id: p.id, type: "projects" }  }
        }
      }
    })

    data
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.includes(:projects).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      params.require(:organization).permit(:name, :website)
    end
end
