# frozen_string_literal: true

class SubscriptionSerializer < ActiveModel::Serializer
  attributes :name, :next_payment_at
end
