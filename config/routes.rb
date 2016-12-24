Rails.application.routes.draw do
  resources :story_points
  resources :users
  resources :channels
  resources :stories
  resources :sprints
  resources :projects
  resources :organizations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
