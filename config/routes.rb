Rails.application.routes.draw do
  namespace :api do
    resource :user, only: [:create, :show]
    resource :sessions, only: [:create]
  end
end
