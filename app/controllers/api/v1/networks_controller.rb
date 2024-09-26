# app/controllers/api/v1/networks_controller.rb
module Api
  module V1
    class NetworksController < Api::V1::ApplicationController

      # GET /api/v1/network/nodes
      def nodes
        return unless valid_query_params?(params, %w[node_id limit order])

        response = self.class.get('/api/v1/network/nodes', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/network/stake
      def stake
        return unless valid_query_params?(params, %w[account_id node_id start_time end_time])

        response = self.class.get('/api/v1/network/stake', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/network/supply
      def supply
        response = self.class.get('/api/v1/network/supply')
        handle_response(response)
      end

      # GET /api/v1/network/fees
      def fees
        response = self.class.get('/api/v1/network/fees')
        handle_response(response)
      end

      # GET /api/v1/network/exchangerate
      def exchangerate
        response = self.class.get('/api/v1/network/exchangerate')
        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:node_id, :limit, :order, :account_id, :start_time, :end_time)
      end
    end
  end
end
