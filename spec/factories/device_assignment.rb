# frozen_string_literal: true

FactoryBot.define do
  factory :device_assignment do
    association :user
    association :device
    operation_type { 'assign' }
    performed_at { Time.current }

    trait :assign do
      operation_type { 'assign' }
    end

    trait :return do
      operation_type { 'return' }
    end
  end
end 