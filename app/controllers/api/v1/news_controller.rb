# frozen_string_literal: true

module Api
  module V1
    class NewsController < ApplicationController
      before_action :authenticate_request, only: %i[create]
      before_action :authorization

      def create
        @news = News.new(news_params)
        if @news.save
          render json: NewsSerializer.new(@news)
                                     .serializable_hash, status: :created
        else
          render json: { error: @news.errors.full_message }
        end
      end

      def news_params
        params.require(:news).permit(:content, :name, :news_type, :category_id)
      end
    end
  end
end
