# frozen_string_literal: true

module OpenWeather
  module Endpoints
    # The OpenWeather gem mixin
    # Notes:  The OpenWeather gem does not come with support for the 2.5 forcast API
    #         Since this is the free version of the forcast, add it
    module Forecast
      def forcast(*args)
        options = args[-1].is_a?(Hash) ? args.pop.dup : {}
        OpenWeather::Models::List.new(get('2.5/forecast', options), options)
      end
    end
  end
end
