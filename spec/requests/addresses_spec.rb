# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Addresses' do
  let(:location_attributes) { { name: 'Home', street: '12', city: 'Seattle', state: 'WA', zipcode: '98117' } }

  describe '#get' do
    it 'return valid list of addresses' do
      create(:address, location_attributes)
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#new' do
    it 'return valid address form' do
      get new_address_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#show' do
    it 'return valid address data' do
      location = create(:address, location_attributes)
      VCR.use_cassette('controller_show_address') do
        get address_path(location)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#create' do
    it 'create valid address' do
      post addresses_path, params: { address: location_attributes }
      expect(response).to redirect_to(address_path(assigns['address']))
    end
  end

  describe '#destroy' do
    it 'create valid address' do
      location = create(:address, location_attributes)
      delete address_path(location)
      expect(response).to redirect_to(root_path)
    end
  end
end
