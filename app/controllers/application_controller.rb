class ApplicationController < ActionController::API
  before_filter :set_headers

  private

  def set_headers
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
