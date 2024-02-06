# frozen_string_literal: true

# AddressesController
#   Purpose:  Primary Controller for the server side web generated interface for Addresses
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
  def index
    @addresses = Address.all
  end

  def show
    @address = Address.find(params[:id])
    @weather = WeatherService.current_weather(@address.zipcode)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to @address
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def address_params
    params.require(:address).permit(:name, :street, :city, :state, :zipcode)
  end
end
