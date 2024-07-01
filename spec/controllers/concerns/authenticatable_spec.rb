require 'rails_helper'

RSpec.describe Authenticatable, type: :controller do
  controller(ApplicationController) do
    include Authenticatable

    def index
      render json: { message: 'Authenticated' }, status: :ok
    end
  end

  describe 'authentication' do
    context 'when valid token is provided' do
      let(:admin_user) { create(:user, user_role: create(:user_role, role: 'admin'), email: 'admin@example.com', password: '123456') }
      let(:token) { JwtService.encode(user_id: admin_user.id) }

      before { request.headers['Authorization'] = "Bearer #{token}" }

      it 'authenticates the user' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Authenticated')
      end
    end

    context 'when invalid token is provided' do
      before { request.headers['Authorization'] = 'Bearer invalid_token' }

      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when no token is provided' do
      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
