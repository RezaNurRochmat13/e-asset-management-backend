# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Device.model_name }
    description { Faker::Lorem.sentence }
    serial_number { Faker::Device.serial }
    asset_code { "ASSET-#{Faker::Number.unique.number(digits: 6)}" }
    association :location
  end
end
