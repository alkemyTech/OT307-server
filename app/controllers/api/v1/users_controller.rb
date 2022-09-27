# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user_for_login, only: :login
      before_action :authenticate_request, only: %i[update]
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

      def update
        if @current_user.update(user_params)
          render json: UserSerializer.new(@current_user).serializable_hash, status: :ok
        else
          render json: @current_user.errors, status: :unprocessable_entity
        end
      end

      private

      def set_user_for_login
        @user = User.kept.find_by!(email: params[:user][:email])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :image)
      end
    end
  end
end
