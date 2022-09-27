# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorization

      def index
        @users = User.kept
        render json: UserSerializer.new(@users).serializable_hash.to_json, status: :ok
      end
    end
  end
end
