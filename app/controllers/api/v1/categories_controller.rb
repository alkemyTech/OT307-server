# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show]
      before_action :authenticate_request, only: %i[show]
      before_action :authorization, only: %i[show]

      def show
        render json: CategorySerializer.new(@category).serializable_hash, status: :ok
      end

      private

      def set_category
        @category = Category.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find any category with ID '#{params[:id]}'" }
      end
    end
  end
end
