class ApplicationController < ActionController::API
  before_action :set_headers


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

  def jira_options
    @jira_options = {
      :username     => ENV['JIRA_USERNAME'],
      :password     => ENV['JIRA_PASSWORD'],
      :site         => 'http://srijan.atlassian.net:443/',
      :context_path => '',
      :auth_type    => :basic
    }
  end

  def jira_client
    @jira_client ||= JIRA::Client.new(jira_options)
  end
end
