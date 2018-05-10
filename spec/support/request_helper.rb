module Requests
  module JsonHelpers
    def body
      @json ||= JSON.parse(response.body)
    end
  end
end