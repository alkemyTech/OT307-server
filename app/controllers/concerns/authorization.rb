# frozen_string_literal: true

module Authorization
  def authorization
    render json: { error: 'Not authorized. Need Administrator role to access' }, status: :forbidden unless administrator?
  end

  def administrator?
    @current_user.role.name == 'administrator'
  end
end
