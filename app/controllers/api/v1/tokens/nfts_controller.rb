# app/controllers/api/v1/tokens/nfts_controller.rb
module Api
  module V1
    module Tokens
      class NftsController < Api::V1::ApplicationController

        # GET /api/v1/tokens/:token_id/nfts
        def index
          return unless valid_query_params?(params, %w[limit order serial_number])

          token_id = params.require(:token_id)
          response = self.class.get("/api/v1/tokens/#{token_id}/nfts", query: filtered_params(params))

          handle_response(response)
        end

        # GET /api/v1/tokens/:token_id/nfts/:serial_number
        def show
          token_id = params.require(:token_id)
          serial_number = params.require(:serial_number)
          response = self.class.get("/api/v1/tokens/#{token_id}/nfts/#{serial_number}")

          handle_response(response)
        end

        # GET /api/v1/tokens/:token_id/nfts/:serial_number/transactions
        def transactions
          token_id = params.require(:token_id)
          serial_number = params.require(:serial_number)
          response = self.class.get("/api/v1/tokens/#{token_id}/nfts/#{serial_number}/transactions")

          handle_response(response)
        end

        private

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:limit, :order, :serial_number)
        end
      end
    end
  end
end
