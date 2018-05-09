class BillingGatewayClient
  CREDENTIALS = Rails.application.secrets.billing_gateway
  URL = '/validate'

  def sufficient_founds?
    http_client.get(URL, authorization_header)
  end

  private

  def http_client
    @_http_client = HttpClient.new(CREDENTIALS[:host])
  end

  def authorization_header
    { 'Authorization' => CREDENTIALS[:token] }
  end
end