Rails.application.routes.draw do
  namespace :api do
    resource :user, only: [:create, :show] do
      resources :game_events, only: :create
    end

    # Note: this endpoint is rate limited to 10 requests per minute
    resource :sessions, only: [:create]    
  end
end
