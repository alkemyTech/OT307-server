# frozen_string_literal: true

module Api
  module V1
    class MembersController < ApplicationController
      before_action :set_member, only: %i[destroy]
      before_action :authenticate_request, only: %i[destroy create]

      def destroy
        @member.discard
      end

      def create
        if member_params[:name].to_i.to_s == '0'
          @member = Member.new(member_params)
          if @member.save
            render json: MemberSerializer.new(@member).serializable_hash, status: :created
          else
            render json: @member.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Name is expected to be a string' }, status: :unprocessable_entity
        end
      end

      private

      def set_member
        @member = Member.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Could not find any member with ID '#{params[:id]}'" }
      end

      def member_params
        params.require(:member).permit(:name, :description, :facebook_url, :instagram_url,
                                       :linkedin_url)
      end
    end
  end
end
