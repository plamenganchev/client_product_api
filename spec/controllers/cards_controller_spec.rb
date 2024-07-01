require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let(:admin_user) { create(:user, user_role: create(:user_role, role: 'admin'), email: 'admin@example.com', password: '123456') }
  let(:client_user) { create(:user, user_role: create(:user_role, role: 'client'), email: 'client@example.com', password: '123456') }
  let(:product) { create(:product, brand: create(:brand, name: "test_brand", status: "active")) }
  let(:card) { create(:card, product: product, user: client_user, status: "active") }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(client_user)
  end

  describe 'POST #issue' do
    it 'creates a new Card' do
      expect {
        post :issue, params: { product_id: product.id, pin: '1234' }
      }.to change(Card, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns unprocessable entity status if card creation fails' do
      allow_any_instance_of(Card).to receive(:save).and_return(false)
      post :issue, params: { product_id: product.id, pin: '1234' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #cancel' do
    it 'cancels the card' do
      card = Card.create!(product: product, user: client_user, activation_number: '1234567890', pin: '1234', status: 'active')
      put :cancel, params: { id: card.id }
      card.reload
      expect(card.status).to eq('cancelled')
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable entity status if card cannot be cancelled' do
      put :cancel, params: { id: 999 }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #generate_report' do
    it 'generates a report of cards' do
      card
      get :generate_report, params: {}
      expect(response).to be_successful
      expect(JSON.parse(response.body)['records'].first['id']).to eq(card.id)
    end
  end
end
