class AddJiraCredentialsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :jira_username, :string
    add_column :users, :jira_password, :string
    add_column :users, :jira_site, :string
  end
end
