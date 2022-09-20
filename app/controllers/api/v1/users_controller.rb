require 'json_web_token'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: :destroy
      before_action :set_user_for_login, only: :login
      before_action :authenticate_request, only: %i[index me update destroy]
      before_action :authorize_user, only: %i[index me destroy]

      def index
       
      end
      