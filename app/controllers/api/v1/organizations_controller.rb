# frozen_string_literal: true

module Api
  module V1
    class OrganizationsController < ApplicationController
      before_action :set_organization, only: %i[public]
      before_action :authenticate_request, only: %i[public]

      def public
        render json: OrganizationSerializer.new(@organization, fields:
        { organization: %i[name image phone address] }).serializable_hash,
               status: :ok
      end

      private

      def set_organization
        @organization = Organization.kept.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Couldn't find organization with ID '#{params[:id]}'" }
      end
    end
  end
end
