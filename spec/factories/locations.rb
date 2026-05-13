# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    name { Faker::Address.city }
    description { "Office branch in #{name}" }
  end
end
