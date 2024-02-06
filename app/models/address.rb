# frozen_string_literal: true

# Address
#   Purpose:  Primary model for addresses
#   Methods:
#     address - returns a concatenated string of the address
#
#  Notes:
#     -
#
class Address < ApplicationRecord
  validates :name, presence: true
  validates :zipcode, presence: true

  def address
    [street, city, state, zipcode].compact.join(', ')
  end
end
