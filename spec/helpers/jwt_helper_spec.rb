require 'rails_helper'

RSpec.describe JwtHelper, type: :helper do


  let(:payload) { { user_id: 1 } }
  let(:token) { JwtHelper.encode(payload) }

  describe '.encode' do
    it 'returns a JWT token' do
      expect(token).not_to be_nil
    end
  end

  describe '.decode' do
    it 'decodes a JWT token' do
      decoded_payload = JwtHelper.decode(token)
      expect(decoded_payload[:user_id]).to eq(1)
    end
  end
end
