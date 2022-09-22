# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user_for_login, only: :login
      # before_action :authenticate_request, only: %i[index me update destroy]
      def login
        if @user.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: @user.id)
          render json: { token: token,
                         exp: 15.minutes.after(Time.zone.now).strftime('%m-%d-%Y %H:%M'),
                         username: @user.first_name }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def set_user_for_login
        @user = User.kept.find_by!(email: params[:user][:email])
      end
    end
  end
end
