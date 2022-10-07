# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update]
      before_action :authenticate_request, only: %i[index show create update]
      before_action :authorization, only: %i[index show create update]

      def index
        @categories = Category.kept
        render json: CategorySerializer.new(@categories,
                                            { fields: { category: [:name] } }).serializable_hash
      end

      def show
        render json: CategorySerializer.new(@category).serializable_hash, status: :ok
      end

      def create
        if category_params[:name].to_i.to_s == '0'
          @category = Category.new(category_params)
          if @category.save
            render json: CategorySerializer.new(@category).serializable_hash, status: :created
          else
            render json: @category.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Name must be a string' }, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          render json: CategorySerializer.new(@category).serializable_hash, status: :ok
        else
          render json: { errors: @category }, status: :unprocessable_entity
        end
      end

      private

      def set_category
        @category = Category.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find any category with ID '#{params[:id]}'" }
      end

      def category_params
        params.require(:category).permit(:name, :description)
      end
    end
  end
end
