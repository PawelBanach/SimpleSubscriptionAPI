module Api
  module V1
    class SubscriptionController < ApplicationController

      def create
        subscription = Subscription.new(subscription_params)
        if subscription.save
          head :ok
        else
          render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index_valid
        binding.pry
      #   todo: all valid subscription with date
      end

      private

      def subscription_params
        params.require(:subscription).permit(:name, :credit_card).merge(subscription_period)
      end

      def subscription_period
        # I made subscription period id days, but minutes/seconds probably would be more accurate
        period = params.require(:subscription).require(:period)
        { activated_at: Time.now, next_payment_at: period.day.from_now }
      end
    end
  end
end
