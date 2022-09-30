# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show]
      before_action :authenticate_request, only: %i[index show]
      before_action :authorization, only: %i[index show]

      def index
        @categories = Category.kept
        render json: CategorySerializer.new(@categories,
                                            { fields: { category: [:name] } }).serializable_hash
      end

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
