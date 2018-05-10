class Subscription < ApplicationRecord
  include ActiveModel::Validations
  BIILING_GATEWAY_RETRY_COUNT = 1

  before_validation :is_expired

  validates :id, uniqueness: true
  validates :credit_card, presence: true, credit_card_number: true
  validates :name, :activated_at, :next_payment_at, presence: true

  after_validation :call_billing_gateway

  def call_billing_gateway
    response = SubscriptionManager.new(BIILING_GATEWAY_RETRY_COUNT).call
    self.billing_id = response.dig('id')
    self.active = response.dig('paid')
    errors.add(:active, response.dig('failure_message')) if response.dig('failure_message').present?
  rescue SubscriptionManager::BillingGatewayUnavailable, HttpClient::ConnectionError
    errors.add(:billing_gateway,'service_unavailable')
  rescue SubscriptionManager::UnknownResponseStatusError
    errors.add(:billing_gateway,'unknown_response_status!')
  end

  def is_expired
    # should be updated with worker
    self.active = false if self.next_payment_at < Time.now
  end
end
