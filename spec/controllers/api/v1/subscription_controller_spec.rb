# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::SubscriptionController, type: :controller do
  describe 'not authorized' do
    it 'returns not authorized error' do
      get :index

      expect(response.status).to eq(401)
      expect(body).to eq('error' => 'unauthorized access')
    end
  end

  let(:subscription_params) do
    {
      name: 'Netflix',
      credit_card: '5274 5763 9425 9961',
      period: 31
    }
  end

  let(:billing_gateway_ok) { 200 }
  let(:billing_gateway_unavailable) { 503 }

  let(:successful_billing_gateway_response) do
    {
      id: SecureRandom.hex(8),
      paid: true,
      failure_message: nil
    }.to_json
  end

  let(:unsuccessful_billing_gateway_response) do
    {
      id: SecureRandom.hex(8),
      paid: false,
      failure_message: 'insufficient_funds'
    }.to_json
  end

  let(:error_billing_gateway_response) do
    'Service Unavailable'
  end

  describe 'authorized' do
    before do
      authorize_user
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates subscription' do
          stub_request(:get, 'http://localhost:4567/validate')
            .to_return(status: billing_gateway_ok, body: successful_billing_gateway_response, headers: {})

          post :create, params: { subscription: subscription_params }

          expect(response.status).to eq(200)
          expect(response.body).to be_empty
        end

        it 'not creates subscription because billing gateway returns insufficient funds' do
          stub_request(:get, 'http://localhost:4567/validate')
            .to_return(status: billing_gateway_ok, body: unsuccessful_billing_gateway_response, headers: {})

          post :create, params: { subscription: subscription_params }

          expect(response.status).to eq(422)
          expect(body).to eq('errors' => ['Active insufficient_funds'])
        end

        it 'not creates subscription because error of billing gateway' do
          stub_request(:get, 'http://localhost:4567/validate')
            .to_return(status: billing_gateway_unavailable, body: error_billing_gateway_response, headers: {})

          post :create, params: { subscription: subscription_params }

          expect(response.status).to eq(422)
          expect(body).to eq('errors' => ['Billing gateway service_unavailable'])
        end
      end

      context 'with invalid(blank) name' do
        it 'returns cannot be blank error' do
          subscription_params[:name] = nil

          post :create, params: { subscription: subscription_params }

          expect(response.status).to eq(422)
          expect(body).to eq('errors' => ["Name can't be blank"])
        end
      end

      context 'with invalid credit card' do
        it 'returns invalid credit card error' do
          subscription_params[:credit_card] = 5_555_666_677_778_888

          post :create, params: { subscription: subscription_params }

          expect(response.status).to eq(422)
          expect(body).to eq('errors' => ['Credit card is invalid'])
        end
      end

      context 'with invalid period' do
        it 'returns invalid credit card error' do
          subscription_params[:period] = '-1'

          get :create, params: { subscription: subscription_params }

          expect(response.status).to eq(422)
          expect(body).to eq('errors' => ['Next payment at must be after activate time'])
        end
      end
    end

    describe 'GET #index' do
      it 'returns empty list of subscriptions' do
        get :index

        expect(response.status).to eq(200)
        expect(body).to be_empty
      end

      it 'returns list of valid subscriptions with next billing date' do
        Array.new(2) { FactoryBot.create(:subscription) }
        Array.new(3) { FactoryBot.create(:subscription, :activated) }

        get :index

        expect(response.status).to eq(200)
        expect(body.length).to eq(3)
      end
    end
  end
end
