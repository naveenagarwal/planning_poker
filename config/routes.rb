Rails.application.routes.draw do
  resources :story_points, :path => '/story-points'
  resources :users do
    member do
      patch 'add_credentials'
    end
  end

  resources :channels
  resources :stories
  resources :sprints
  resources :projects
  resources :organizations

  post '/login', to: "application#login"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
