# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound || JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
