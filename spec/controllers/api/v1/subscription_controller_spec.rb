# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionController, type: :controller do
  describe 'not authorized' do
    it 'returns not authorized error'
  end

  describe 'authorized' do
    describe 'POST #create' do
      context 'valid parameters' do
        it 'creates subscription' do
        end

        it 'not creates subscription because billing gateway returns insufficient funds' do
        end

        it 'not creates subscription because error of billing gateway' do
        end
      end

      context 'invalid name' do
      end

      context 'invalid credit card' do
      end

      context 'invalid period' do
      end

      context ''
    end

    describe 'GET #index' do
      it 'returns empty list of subscriptions' do
      end

      it 'returns list of subscriptions with next billing date' do
      end
    end
  end
end
