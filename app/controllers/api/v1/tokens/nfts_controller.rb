# app/controllers/api/v1/tokens/nfts_controller.rb
module Api
  module V1
    module Tokens
      class NftsController < Api::V1::ApplicationController
        include HTTParty
        base_uri 'https://mainnet-public.mirrornode.hedera.com'

        # GET /api/v1/tokens/:token_id/nfts
        def index
          unless valid_query_params?(params, %w[limit order serial_number])
            return render json: { error: 'Invalid query parameters' }, status: :bad_request
          end

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

        # Validate query parameters for the nfts endpoints
        def valid_query_params?(params, allowed_params)
          params.keys.all? { |key| allowed_params.include?(key) }
        end

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:limit, :order, :serial_number)
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
end
