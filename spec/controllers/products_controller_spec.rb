require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:admin_user) { create(:user,:admin) }
  let(:client_user) { create(:user, :client) }
  let(:product) { create(:product, brand: create(:brand, name: "test_brand", status: "active")) }
  let(:valid_attributes) { { name: 'Test Product', description: 'Test Description', price: 10.0, status: 'active',
                             brand: create(:brand, name: 'test_brand', country: 'DE'), } }
  let(:card) { create(:card, product: product, user: client_user, status: "active") }

  before do
    # Mock authentication with JWT token
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #search' do
    it 'returns a success response' do
      product = Product.create! valid_attributes
      get :search, params: { query: 'Test' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['data'].first['name']).to eq(product.name)
    end
  end
  describe 'POST #assign_to_user' do
    context 'as an admin user' do
      it 'assigns a product to a user' do
        request.headers['Authorization'] = "Bearer #{JwtService.encode(user_id: admin_user.id)}"
        post :assign_to_user, params: { user_id: client_user.id, product_id: product.id }
        expect(response).to have_http_status(:ok)
        expect(client_user.products).to include(product)
      end

      it 'returns unprocessable entity status if duplicate record' do
        client_user.products << product
        post :assign_to_user, params: { user_id: client_user.id, product_id: product.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #accessible' do
    context 'as a client user' do
      before { allow(controller).to receive(:current_user).and_return(client_user) }

      it 'returns accessible products for the client user' do
        client_user.products << product
        get :accessible, params: {}
        expect(response).to be_successful
        expect(JSON.parse(response.body)['data'].first['id']).to eq(product.id)
      end
    end
  end
end
