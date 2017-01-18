class ApplicationController < ActionController::API
  before_action :set_headers
  before_action :check_token, except: [:login]

  def login
    user = User.find_by(email: params[:email])
    if user.present?
      render json: {  success: true, email: user.email, name: user.name, id: user.id, org_id: user.organization_id }
    else
      render json: {  success: false, status: 422 }
    end

  end

  private

  def set_headers
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  def check_token
    return if request.headers["HTTP_USER_ID"].present?

    return render json: {  message: "Invalid access", status: 422 }
  end

  def jira_options
    return @jira_options if @jira_options.present?
    user = User.find(request.headers["HTTP_USER_ID"])
    @jira_options = {
      :username     => user.jira_username,
      :password     => user.jira_password,
      :site         => user.jira_site,
      :context_path => '',
      :auth_type    => :basic
    }
  end

  def jira_client
    @jira_client ||= JIRA::Client.new(jira_options)
  end
end
