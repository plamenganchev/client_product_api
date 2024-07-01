module Api::V1
  class ClientSessionsController < ApplicationController
    def create
      client = User.find_by(authentication_token: params[:authentication_token])

      if client
        token = JwtService.encode(user_id: client.id)
        render json: { token: token, user: client.as_json(only: [:id, :email, :role]) }, status: :ok
      else
        render json: { error: 'Invalid client token' }, status: :unauthorized
      end
    end
  end
end
