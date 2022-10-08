# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/auth/login", to: "users#login"
      post "auth/register", to: "users#create"
      resources :users, only: %i[index update]

      get "/users", to: "users#index"
      get "auth/me", to: "users#me"

      resources :categories, only: %i[index show create update destroy]
      resources :organizations, only: %i[update] do
        get 'public', on: :member
      resources :members, only: %i[destroy]
      end
      resources :news, only: %i[create update show destroy]
      resources :members, only: %i[create]
    end
  end
end
