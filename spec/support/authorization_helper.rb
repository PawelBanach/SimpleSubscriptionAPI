# frozen_string_literal: true

module AuthorizationHelper
  CREDENTIALS = Rails.application.secrets.credentials

  def authorize_user
    @request.headers.merge!(authorization_token)
  end

  def authorization_token
    {
      'Authorization' => "Basic #{Base64.encode64(credentials)}"
    }
  end

  def credentials
    "#{CREDENTIALS[:user]}:#{CREDENTIALS[:password]}"
  end
end
