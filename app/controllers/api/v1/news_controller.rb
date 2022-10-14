# frozen_string_literal: true

module Api
  module V1
    class NewsController < ApplicationController
      before_action :set_news, only: %i[update show destroy]
      before_action :authenticate_request, only: %i[create update show destroy index]
      before_action :authorization, only: %i[create update show destroy]
      after_action { pagy_headers_merge(@pagy) if @pagy }

      def index
        @pagy, @news = pagy(News.kept)
        render json: { news_serializer: render_serializer,
                       pages_information: pagy_metadata(@pagy) }
      end

      def create
        @news = News.new(news_params)
        if @news.save
          render json: NewsSerializer.new(@news)
                                     .serializable_hash, status: :created
        else
          render json: @news.errors, status: :unprocessable_entity
        end
      end

      def update
        if @news.update(news_params)
          render json: NewsSerializer.new(@news).serializable_hash, status: :ok
        else
          render json: @news.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: NewsSerializer.new(@news).serializable_hash, status: :ok
      end

      def destroy
        @news.discard
        head :no_content
      end

      private

      def render_serializer
        NewsSerializer.new(@news,
                           { fields: { news: %i[name content] } }).serializable_hash
      end

      def set_news
        @news = News.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find news with ID '#{params[:id]}'" }
      end

      def news_params
        params.require(:news).permit(:name, :content, :category_id)
      end
    end
  end
end
