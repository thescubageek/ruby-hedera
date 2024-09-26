# app/controllers/api/v1/accounts_controller.rb
module Api
  module V1
    class AccountsController < Api::V1::ApplicationController

      # GET /api/v1/accounts
      def index
        return unless valid_query_params?(params, %w[account_id public_key balance])

        response = self.class.get('/api/v1/accounts', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/accounts/:id
      def show
        response = self.class.get("/api/v1/accounts/#{params.require(:id)}")
        handle_response(response)
      end

      # GET /api/v1/nfts
      def nfts
        return unless valid_query_params?(params, %w[account_id serial_number token_id])

        response = self.class.get('/api/v1/nfts', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/rewards
      def rewards
        return unless valid_query_params?(params, %w[account_id start_time end_time])

        response = self.class.get('/api/v1/rewards', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/tokens
      def tokens
        return unless valid_query_params?(params, %w[token_id])

        response = self.class.get('/api/v1/tokens', query: filtered_params(params))
        handle_response(response)
      end

      private

      # Filter the valid params based on allowed params for each endpoint
      def filtered_params(params)
        params.permit(:account_id, :public_key, :balance, :serial_number, :token_id, :start_time, :end_time)
      end
    end
  end
end
