# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    name 'Netflix'
    credit_card  '5274 5763 9425 9961'
    activated_at { 2.months.ago }
    next_payment_at { 1.months.from_now }
    active false
    billing_id 12_345_678
  end

  trait :activated do
    active true
  end
end
