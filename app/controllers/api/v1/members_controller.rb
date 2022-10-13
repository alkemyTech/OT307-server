# frozen_string_literal: true

module Api
  module V1
    class MembersController < ApplicationController
      before_action :set_member, only: %i[destroy]
      before_action :authenticate_request, only: %i[destroy]

      def destroy
        @member.discard
      end

      private

      def set_member
        @member = Member.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find any member with ID '#{params[:id]}'" }
      end
    end
  end
end
