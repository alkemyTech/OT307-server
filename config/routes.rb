# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/auth/login", to: "users#login"
      post "auth/register", to: "users#create"

      get "/users", to: "users#index"
      get "auth/me", to: "users#me"
    end
  end
end
