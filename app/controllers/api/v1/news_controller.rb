# frozen_string_literal: true

module Api
  module V1
    class NewsController < ApplicationController
      before_action :set_news, only: %i[destroy]
      before_action :authenticate_request, only: %i[destroy]
      before_action :authorization, only: %i[destroy]

      def destroy
        @news.discard
        head :no_content
      end

      private

      def set_news
        @news = News.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find news with ID '#{params[:id]}'" }
      end
      
      def news_params
        params.require(:news).permit(:content, :name, :news_type, :category_id)
      end


    end
  end
end
