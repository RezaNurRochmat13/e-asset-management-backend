# frozen_string_literal: true

FactoryBot.define do
  factory :asset_log do
    association :asset
    association :user
    association :location
    action { "created" }
    remarks { "Initial log" }
  end
end
