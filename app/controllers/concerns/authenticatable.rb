module Authenticatable
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user
  end

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      decoded_token = decode(token)
      @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
    end
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
  end

  def decode(token)
    body = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end

  private

  def secret_key
    Rails.application.credentials[:secret_key_base]
  end


end