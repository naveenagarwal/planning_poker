class ApplicationController < ActionController::API
  before_filter :set_headers


  def login
    user = User.find_by(email: params[:email])
    if user.present?
      render json: {  success: true, email: user.email, name: user.name }
    else
      render json: {  success: false, status: 422 }
    end

  end

  private

  def set_headers
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
