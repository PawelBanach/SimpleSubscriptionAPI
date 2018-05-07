module API
  class ApplicationController < ActionController::API
    before_action :authorized?

    def authorized?
      binding.pry
    end

    def render_unauthorized
      render json: { error: 'unauthorized access' }, status: :unauthorized
    end
  end
end
