# frozen_string_literal: true

module Authorization
  def authorization
    return if administrator?

    render json: { error: 'Not authorized. Need Administrator role to access' },
           status: :forbidden
  end

  def administrator?
    @current_user.role.name == 'administrator'
  end
end
