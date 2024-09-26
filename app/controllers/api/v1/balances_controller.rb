# app/controllers/api/v1/balances_controller.rb
module Api
  module V1
    class BalancesController < Api::V1::ApplicationController

      # GET /api/v1/balances
      def index
        return unless valid_query_params?(params, %w[account_id timestamp limit order])

        response = self.class.get('/api/v1/balances', query: filtered_params(params))
        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:account_id, :timestamp, :limit, :order)
      end
    end
  end
end
