# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Addresses', type: :request do
  let(:location_attributes) { { name: 'Home', street: '12', city: 'Seattle', state: 'WA', zipcode: '98117' } }

  describe '#get' do
    it 'return valid list of addresses' do
      create(:address)
      get api_addresses_path(:json)
      expect(response).to match_json_schema('addresses')
    end
  end

  describe '#show' do
    it 'return valid address data' do
      VCR.use_cassette('controller_show_address') do
        location = create(:address)
        get api_address_path(location, :json)
        expect(response).to match_json_schema('address')
      end
    end
  end

  describe '#create' do
    it 'create valid address' do
      post api_addresses_path(:json), params: { address: location_attributes }
      expect(response).to have_http_status(:success)
    end
  end

  describe '#destroy' do
    it 'create valid address' do
      location = create(:address)
      delete api_address_path(location, :json)
      expect(response).to have_http_status(:success)
    end
  end
end
