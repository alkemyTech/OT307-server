# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]
      before_action :authenticate_request, only: %i[index show create update destroy]
      before_action :authorization, only: %i[index show create update destroy]
      after_action { pagy_headers_merge(@pagy) if @pagy }

      def index
        @pagy, @categories = pagy(Category.kept)
        render json: { categories_serializer: render_serializer,
                       pages_information: pagy_metadata(@pagy) }
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

      def destroy
        @category.discard
        head :no_content
      end

      private

      def render_serializer
        CategorySerializer.new(@categories,
                               { fields: { category: [:name] } }).serializable_hash
      end

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
