class SubscriptionManager
  class UnknownResponseStatusError < StandardError; end

  attr_reader :subscription, :errors

  def initialize(retry_count)
    @retry_count = retry_count
  end


  def call
    response = BillingGatewayClient.new.sufficient_founds?
    case response.code
    when '200'
      handle_successful_response(response.body)
    when '503'
      handle_unsuccessful_response(response.body)
    else
      raise UnknownResponseStatusError
    end
  end

  private

  def handle_successful_response(body)
    body = parsed_body(body)
    body.dig('paid') ? create_negative_response({ paid: ['cannot be processed'] }) : create_subscription(body.dig('id'))
  end

  def handle_unsuccessful_response(body)
    if @retry_count > 0
      @retry_count -= 1
      call
    else
      create_negative_response({ server: [body] })
    end
  end

  def create_subscription(id)
    @subscription = Subscription.new(id: id)
    @subscription.save ? true : create_negative_response(@subscription.errors.messages)
  end

  def create_negative_response(errors)
    @errors = errors
    false
  end

  def parsed_body(body)
    JSON.parse(body)
  end
end