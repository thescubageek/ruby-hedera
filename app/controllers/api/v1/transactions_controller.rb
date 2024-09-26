# app/controllers/api/v1/transactions_controller.rb
module Api
  module V1
    class TransactionsController < Api::V1::ApplicationController
      # GET /api/v1/transactions
      def index
        return unless valid_query_params?(params, %w[transaction_id account_id result type timestamp limit order])

        response = self.class.get('/api/v1/transactions', query: filtered_params(params))

        handle_response(response)
      end

      # GET /api/v1/transactions/:transaction_id
      def show
        response = self.class.get("/api/v1/transactions/#{params[:transaction_id]}")

        handle_response(response)
      end

      # GET /api/v1/transactions/:transaction_id/records
      def records
        response = self.class.get("/api/v1/transactions/#{params[:transaction_id]}/records")

        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:transaction_id, :account_id, :result, :type, :timestamp, :limit, :order)
      end
    end
  end
end
