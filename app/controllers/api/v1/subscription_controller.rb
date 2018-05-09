module Api
  module V1
    class SubscriptionController < ApplicationController
      RETRY_COUNT = 1

      def create
        sub_manager = SubscriptionManager.new(RETRY_COUNT)
        if sub_manager.call
          render json: { message: "Successfully created product subscription ##{sub_manager.subscription.id}" },
                 status: :ok
        else
          render json: { errors: sub_manager.errors },
                 status: :unprocessable_entity
        end
      end
    end
  end
end
