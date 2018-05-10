class SubscriptionManager
  class UnknownResponseStatusError < StandardError; end
  class BillingGatewayUnavailable < StandardError; end

  def initialize(retry_count)
    @retry_count = retry_count
  end


  def call
    response = BillingGatewayClient.new.sufficient_founds?
    case response.code
    when '200'
      parsed_body(response.body)
    when '503'
      handle_unsuccessful_response
    else
      raise UnknownResponseStatusError
    end
  end

  private

  def handle_unsuccessful_response
    if @retry_count > 0
      @retry_count -= 1
      call
    else
      raise BillingGatewayUnavailable
    end
  end

  def parsed_body(body)
    JSON.parse(body)
  end
end