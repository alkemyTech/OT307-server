# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/auth/login", to: "users#login"
      post "auth/register", to: "users#create"
      get "auth/me", to: "users#me"
      
      resources :activities, only: %i[create update]
      resources :categories, only: %i[index show create update destroy]
      resources :members, only: %i[create index update destroy]
      resources :news, only: %i[create update show destroy index]
      resources :organizations, only: %i[update] do
        get 'public', on: :member
      end
      resources :users, only: %i[index update]
    end
  end
end
