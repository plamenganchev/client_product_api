require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password123', password_confirmation: 'password123', user_role_id: user_role.id } }
  let(:invalid_attributes) { { email: 'invalid_email', password: 'password123', password_confirmation: 'password123', user_role_id: user_role.id } }
  let(:admin_user) { create(:user,:admin) }
  let(:client_user) { create(:user, :client) }
  let(:user_role) { create(:user_role, role: 'client') }

  before do
    # Mock authentication with JWT token
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")

        user = User.last
        json_response = JSON[response.body]
        expect(json_response['email']).to eq(user.email)
        expect(json_response['user_role_id']).to eq(user.user_role_id)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable_entity status' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end
end
