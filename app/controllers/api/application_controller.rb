# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    CREDENTIALS = Rails.application.secrets.credentials

    before_action :authorized?

    private

    def valid_credentials?
      @auth&.credentials == [CREDENTIALS[:user], CREDENTIALS[:password]]
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      render_unauthorized unless @auth.provided? && @auth.basic? && valid_credentials?
    end

    def render_unauthorized
      render json: { error: 'unauthorized access' }, status: :unauthorized
    end
  end
end
