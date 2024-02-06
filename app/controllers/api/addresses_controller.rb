# frozen_string_literal: true

module Api
  # Api::AddressesController
  #   Purpose:  Primary Controller for the server side API, returns JSON responses
  #   Methods:
  #     index - returns all addresses store in the database
  #     show - shows the address details including weather information for the address
  #     new - displays form for the creation of a new address
  #     create - creates a new address in the database with the submitted parameters
  #     destroy - delete address from the database
  #
  #  Notes:
  #     - updating and address is not supported
  #
  class AddressesController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      addresses = Address.all
      render json: addresses
    end

    def show
      address = Address.find(params[:id])
      weather = WeatherService.current_weather(address.zipcode)
      render json: address_json(address, weather)
    end

    def create
      @address = Address.new(address_params)

      if @address.save
        render json: @address, status: :created, location: @address
      else
        render json: @address.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @address = Address.find(params[:id])
      @address.destroy
    end

    private

    def address_params
      params.require(:address).permit(:name, :street, :city, :state, :zipcode)
    end

    def address_json(address, weather)
      { id: address.id,
        name: address.name,
        street: address.street,
        city: address.city,
        state: address.state,
        zipcode: address.zipcode,
        created_at: address.created_at,
        updated_at: address.updated_at,
        weather: }
    end
  end
end
