# spec/controllers/reports_controller_spec.rb
require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:admin_user) { create(:user,:admin) }
  let(:client_user) { create(:user, :client) }
  let(:brand) { create(:brand) }
  let(:product) { create(:product, brand: brand) }
  let!(:card) { create(:card, product: product, user: client_user, status: "active") }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #by_brand' do
    it 'returns a list of products for the specified brand' do
      get :by_brand, params: { brand_id: brand.id }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['data'].size).to eq(1)
      expect(JSON.parse(response.body)['data'].first['id']).to eq(product.id)
    end
  end

  describe 'GET #by_client' do
    it 'returns a list of cards for the specified client' do
      get :by_client, params: { client_id: client_user.id }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['data'].size).to eq(1)
      expect(JSON.parse(response.body)['data'].first['id']).to eq(card.id)
    end
  end
end
