# frozen_string_literal: true

require 'net/http'
require 'uri'

class HttpClient
  class ConnectionError < StandardError; end
  def initialize(uri)
    @uri = URI(uri)
  end

  def get(path, headers = {})
    request(Net::HTTP::Get.new(path), default_headers.merge(headers))
  end

  private

  def request(req, headers)
    Net::HTTP.start(@uri.host, @uri.port) do |http|
      headers.each { |k, v| req.add_field k.to_s, v }
      http.request(req)
    end
  rescue Net::ReadTimeout => e
    raise ConnectionError, e
  rescue SystemCallError => e
    raise ConnectionError, e
  end

  def default_headers
    {
      'Content-Type' => 'application/json'
    }
  end
end
