
module Api::V1::Authenticatable
  extend ActiveSupport::Concern
  included do
      before_action :authenticate_user
    end

    def authenticate_user
      token = request.headers['Authorization']&.split(' ')&.last

      if token.present?
        decoded_token = JwtService.decode(token)
        @current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token
        log_api_request
      end
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def current_user
      @current_user
    end
    private
    def log_api_request
      begin
        ApiRequest.create({
          endpoint: request.fullpath,
          remote_ip: request.remote_ip,
          payload: params,
          user: @current_user}
        )
      rescue StandardError => e
        #Maybe log this in something like sentry
      end
    end
  end
