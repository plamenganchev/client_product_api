require 'rails_helper'

RSpec.describe Api::V1::BrandsController, type: :controller do
  let(:valid_attributes) { { name: 'Test Brand', country: 'DE', status: 'active' } }
  let(:admin_user) { create(:user,:admin) }
  let(:client_user) { create(:user, :client) }


  describe 'GET #index' do
    it 'returns a success response' do
      request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: admin_user.id)}"
      brand = Brand.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq([brand.as_json])
    end
  end

  describe 'POST #create' do
    context 'as an admin user' do
      it 'creates a new Brand' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: admin_user.id)}"
        expect {
          post :create, params: { brand: valid_attributes }
        }.to change(Brand, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'as a client user' do
      it 'returns unauthorized error' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: client_user.id)}"
        post :create, params: { brand: valid_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    let!(:brand) { create(:brand, country: "DE", status: 'active') }

    context 'as an admin user' do
      it 'updates the requested brand' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: admin_user.id)}"
        put :update, params: { id: brand.to_param, brand: { name: 'Updated Brand Name' } }
        brand.reload
        expect(brand.name).to eq('Updated Brand Name')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'as a client user' do
      it 'returns unauthorized error' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: client_user.id)}"
        put :update, params: { id: brand.to_param, brand: { name: 'Updated Brand Name' } }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:brand) { create(:brand, country: "DE", status: 'active') }

    context 'as an admin user' do
      it 'destroys the requested brand' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: admin_user.id)}"
        expect {
          delete :destroy, params: { id: brand.to_param }
        }.to change(Brand, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'as a client user' do
      it 'returns unauthorized error' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: client_user.id)}"
        delete :destroy, params: { id: brand.to_param }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
