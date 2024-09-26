# app/controllers/api/v1/transactions_controller.rb
module Api
  module V1
    class TransactionsController < Api::V1::ApplicationController
      include HTTParty
      base_uri 'https://mainnet-public.mirrornode.hedera.com'

      # GET /api/v1/transactions
      def index
        unless valid_query_params?(params, %w[transaction_id account_id result type timestamp limit order])
          return render json: { error: 'Invalid query parameters' }, status: :bad_request
        end

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

      # Validate query parameters for the transactions endpoint
      def valid_query_params?(params, allowed_params)
        params.keys.all? { |key| allowed_params.include?(key) }
      end

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:transaction_id, :account_id, :result, :type, :timestamp, :limit, :order)
      end

      # Handle response from the Hedera API and return appropriate status
      def handle_response(response, success_status = :ok)
        if response.code == 200 || response.code == success_status
          render json: response.parsed_response, status: success_status
        else
          render json: { error: "Hedera API Error: #{response['message']}" }, status: response.code
        end
      end
    end
  end
end
