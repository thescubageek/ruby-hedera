# app/controllers/api/v1/accounts/allowances_controller.rb
module Api
  module V1
    module Accounts
      class AllowancesController < Api::V1::ApplicationController
        include HTTParty
        base_uri 'https://mainnet-public.mirrornode.hedera.com'

        # GET /api/v1/accounts/:account_id/allowances
        def index
          account_id = params.require(:account_id)
          response = self.class.get("/api/v1/accounts/#{account_id}/allowances")

          handle_response(response)
        end

        # GET /api/v1/accounts/:account_id/allowances/:allowance_id
        def show
          account_id = params.require(:account_id)
          allowance_id = params.require(:allowance_id)
          response = self.class.get("/api/v1/accounts/#{account_id}/allowances/#{allowance_id}")

          handle_response(response)
        end

        private

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
