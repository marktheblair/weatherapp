# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    name { 'Home' }
    street { '123 First Street' }
    city { 'Seattle' }
    state { 'WA' }
    zipcode { '98117' }
  end
end
