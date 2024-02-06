# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService, type: :model do
  describe '#weather' do
    it 'looks up the current weather' do
      VCR.use_cassette('basic_weather') do
        weather = described_class.current_weather('98117')
        expect(weather).to include(description: be_a(String), temp: be_a(Numeric),
                                   forcast: be_a(Array))
      end
    end

    it 'looks up the current weather fails' do
      VCR.use_cassette('basic_weather_fails') do
        weather = described_class.current_weather('')
        expect(weather).to be_nil
      end
    end
  end
end
