# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern
  def authorization
    return if administrator?

    render json: { error: 'Not authorized. Need Administrator role to access' },
           status: :forbidden
  end

  def owner?
    params[:id].to_i == @current_user.id
  end

  def administrator?
    @current_user.role.name == 'administrator'
  end

  def ownership?
    return if administrator? || owner?

    render json: { errors: 'Unauthorized access. Need administrator role to access' },
           status: :forbidden
  end
end
