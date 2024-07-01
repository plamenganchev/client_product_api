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
    @current_user ? log_api_request({user: @current_user}) : log_api_request({api_key: token})
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def log_api_request(additional_params)
    begin
      ApiRequest.create({
        endpoint: request.fullpath,
        remote_ip: request.remote_ip,
        payload: params}.merge(additional_params)
      )
    rescue StandardError => e
      #Maybe log this in something like sentry
    end
  end
end