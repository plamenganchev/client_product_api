module Api::V1
  class UsersController < ApplicationController
    def create
      user = User.new(permitted_params)
      user.user_role_id = UserRole.find_by(role: 'client')&.id
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_role_id)
    end
  end
end
