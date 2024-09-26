# app/controllers/api/v1/tokens_controller.rb
module Api
  module V1
    class TokensController < Api::V1::ApplicationController

      # GET /api/v1/tokens
      def index
        return unless valid_query_params?(params, %w[token_id limit order])

        response = self.class.get('/api/v1/tokens', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/tokens/:token_id
      def show
        response = self.class.get("/api/v1/tokens/#{params[:token_id]}")
        handle_response(response)
      end

      # GET /api/v1/tokens/:token_id/balances
      def balances
        return unless valid_query_params?(params, %w[limit order account_id balance])

        response = self.class.get("/api/v1/tokens/#{params[:token_id]}/balances", query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/tokens/:token_id/nfts
      def nfts
        return unless valid_query_params?(params, %w[limit order serial_number])

        response = self.class.get("/api/v1/tokens/#{params[:token_id]}/nfts", query: filtered_params(params))
        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:token_id, :limit, :order, :account_id, :balance, :serial_number)
      end
    end
  end
end
