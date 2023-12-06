Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create]
      resources :search_skills, only: [:index]
      resources :meetings, only: [:create, :update, :destroy]
      resources :add_skills, only: [:create], controller: 'skills', action: 'create'
    end
  end
end
