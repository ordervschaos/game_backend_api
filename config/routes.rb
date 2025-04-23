Rails.application.routes.draw do
  namespace :api do
    resource :user, only: [:create, :show] do
      resources :game_events, only: :create
    end
    resource :sessions, only: [:create]
    
  end
end
