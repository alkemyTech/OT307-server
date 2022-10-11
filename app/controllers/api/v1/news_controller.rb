# frozen_string_literal: true

module Api
  module V1
    class NewsController < ApplicationController
      before_action :set_news, only: %i[update]
      before_action :authenticate_request, only: %i[update]
      before_action :authorization, only: %i[update]

      def update
        @news.update(news_params)
        render json: NewsSerializer.new(@news).serializable_hash, status: :ok
      end

      private

      def set_news
        @news = News.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find news with ID '#{params[:id]}'" }
      end

      def news_params
        params.require(:news).permit(:content, :name, :category_id)
      end
    end
  end
end
