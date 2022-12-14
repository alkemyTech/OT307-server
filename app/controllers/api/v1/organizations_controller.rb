# frozen_string_literal: true

module Api
  module V1
    class OrganizationsController < ApplicationController
      before_action :set_organization, only: %i[public update]
      before_action :authenticate_request, only: %i[public update]
      before_action :authorization, only: %i[update]

      def public
        render json: OrganizationSerializer.new(@organization, fields:
        # rubocop:disable Layout/LineLength
        { organization: %i[name image phone address facebook_url instagram_url linkedin_url] }).serializable_hash,
               # rubocop:enable Layout/LineLength
               status: :ok
      end

      def update
        if @organization.update(org_params)
          render json: OrganizationSerializer.new(@organization).serializable_hash, status: :ok
        else
          render json: @organization.errors, status: :unprocessable_entity
        end
      end

      private

      def set_organization
        @organization = Organization.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Couldn't find organization with ID '#{params[:id]}'" }
      end

      def org_params
        params.require(:organization).permit(:about_us_text, :address, :email, :name, :phone,
                                             :welcome_text)
      end
    end
  end
end
