# app/controllers/api/v1/blocks_controller.rb
module Api
  module V1
    class BlocksController < Api::V1::ApplicationController

      # GET /api/v1/blocks
      def index
        return unless valid_query_params?(params, %w[block_number consensus_start consensus_end limit order])

        response = self.class.get('/api/v1/blocks', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/blocks/:id
      def show
        response = self.class.get("/api/v1/blocks/#{params.require(:id)}")
        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:block_number, :consensus_start, :consensus_end, :limit, :order)
      end
    end
  end
end
