# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user_for_login, only: :login
      before_action :authenticate_request, only: %i[index me update]
      before_action :authorization, only: %i[index]

      def index
        @users = User.kept
        render json: UserSerializer.new(@users).serializable_hash.to_json, status: :ok
      end

      def me
        render json: UserSerializer.new(@current_user).serializable_hash, status: :ok
      end

      def create
        @user = User.new(user_params)
        #@user.role = Role.find(params[:user][:role_id])
        if @user.save
          @token = JsonWebToken.encode(user_id: @user.id)
          Sendeable.send_welcome_email(@user, 'Bienvenido a SOMOS MAS!')
          render_user
        else
          render_error
        end
      end

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
        begin
          @user = User.kept.find_by!(email: params[:user][:email])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :image, :role_id)
      end

      def render_error
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end

      def render_user
        render json: {
          user: UserSerializer.new(@user).serializable_hash,
          token: @token
        }, status: :created
      end
    end
  end
end
