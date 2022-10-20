# frozen_string_literal: true

module Api
  module V1
    class ActivitiesController < ApplicationController
      before_action :authenticate_request, only: %i[create]
      before_action :authorization, only: %i[create]

      def create
        @activity = Activity.new(activity_params)
        if @activity.save
          render json: ActivitySerializer.new(@activity).serializable_hash,
                 status: :created
        else
          render json: @activity.errors, status: :unprocessable_entity
        end
      end

      private

      def activity_params
        params.require(:activity).permit(:name, :content, :image)
      end
    end
  end
end
