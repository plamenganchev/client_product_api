module Authenticatable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user
  end

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      decoded_token = JwtService.decode(token)
      @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
    end
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

end