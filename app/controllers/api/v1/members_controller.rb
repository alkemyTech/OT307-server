# frozen_string_literal: true

module Api
  module V1
    class MembersController < ApplicationController
      before_action :set_member, only: %i[destroy update]
      before_action :authenticate_request, only: %i[destroy create index update]
      before_action :authorization, only: %i[index]

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

      def update
        if member_params[:name].to_i.to_s == '0'
          if @member.update(member_params)
            render json: MemberSerializer.new(@member).serializable_hash, status: :ok
          else
            render json: @member.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Name is expected to be a string' }, status: :unprocessable_entity
        end
      end

      def index
        @members = Member.kept
        render json: MemberSerializer.new(@members).serializable_hash, status: :ok
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
