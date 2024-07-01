class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    return unless user.admin?
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: { token: token, user: user.as_json(only: [:id, :email, :role]) }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
