# frozen_string_literal: true

# WeatherService
#   Purpose:  Primary interface for getting weather information from an outside source
#   Methods:
#     current_weather - returns weather information for the given zipcode
#
#  Notes:
#     - caching - returned weather data is cached for 30 minutes for each zipcode
#     - abstraction - all returned data is in plain ruby objects, api specific objects
#                     are NOT returned to the caller
#     - gem library - uses the OpenWeather gem to retrieve from Open Weather https://openweathermap.org/
#
class WeatherService
  class << self
    @client = nil

    def current_weather(zipcode)
      cached = true
      result = Rails.cache.fetch("#{zipcode}/weather", expires_in: 30.minutes) do
        cached = false
        build_weather(zipcode)
      end
      result[:cached] = cached if result.present?
      result
    end

    private

    def client
      @client ||= OpenWeather::Client.new(
        api_key: Rails.application.credentials.open_weather.api_key
      )
    end

    def build_weather(zipcode)
      begin
        weather = client.current_weather(zip: zipcode)
      rescue OpenWeather::Errors::Fault => e
        Rails.logger.error e.message
        return nil
      end
      weather_entry(weather, zipcode)
    end

    def weather_entry(weather, zipcode)
      { dt: weather.dt,
        timezone: weather.timezone,
        description: weather.weather.first['description'],
        temp: weather.main.temp_f,
        temp_max: weather.main.temp_max_f,
        temp_min: weather.main.temp_min_f,
        forcast: build_forcast(client, weather.timezone, zipcode) }
    end

    def build_forcast(client, timezone, zipcode)
      begin
        forcast = client.forcast(zip: zipcode)
      rescue OpenWeather::Errors::Fault => e
        Rails.logger.debug e.message
        return nil
      end
      parse_forcast(forcast, timezone)
    end

    def parse_forcast(forcast, timezone)
      final_forcast = []
      forcast.list.each do |entry|
        entry_date = entry.dt.getlocal(timezone).to_date
        if final_forcast.blank? || final_forcast.last[:date] != entry_date
          final_forcast << { date: entry_date, forcasts: [forcast_entry(entry)] }
        else
          final_forcast.last[:forcasts] << forcast_entry(entry)
        end
      end
      final_forcast
    end

    def forcast_entry(entry)
      { dt: entry.dt,
        description: entry.weather.first['description'],
        temp: entry.main.temp_f }
    end
  end
end
