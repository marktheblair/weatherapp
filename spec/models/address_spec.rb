# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address do
  describe '#address' do
    it 'return valid data for a given valid address' do
      location = create(:address, name: 'Home', street: '123 Jones St', city: 'Seattle', state: 'WA', zipcode: '98117')
      expect(location.address).to eq('123 Jones St, Seattle, WA, 98117')
    end

    it 'return valid data for a given valid address with only name and zipcode' do
      location = create(:address, name: 'Home', street: nil, city: nil, state: nil, zipcode: '98117')
      expect(location.address).to eq('98117')
    end

    it 'return invalid for missiing data' do
      expect(build(:address, name: nil, street: nil, city: nil, state: nil, zipcode: nil)).not_to be_valid
    end

    it 'return invalid for missiing zipcode data' do
      expect(build(:address, zipcode: nil)).not_to be_valid
    end

    it 'return invalid for missiing name data' do
      expect(build(:address, name: nil)).not_to be_valid
    end
  end
end
