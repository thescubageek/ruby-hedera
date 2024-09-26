# app/controllers/api/v1/contracts/results_controller.rb
module Api
  module V1
    module Contracts
      class ResultsController < Api::V1::ApplicationController
        include HTTParty
        base_uri 'https://mainnet-public.mirrornode.hedera.com'

        # GET /api/v1/contracts/results
        def index
          unless valid_query_params?(params, %w[contract_id timestamp limit order])
            return render json: { error: 'Invalid query parameters' }, status: :bad_request
          end

          response = self.class.get('/api/v1/contracts/results', query: filtered_params(params))

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:id
        def show
          response = self.class.get("/api/v1/contracts/results/#{params[:id]}")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:transactionIdOrHash/actions
        def actions
          response = self.class.get("/api/v1/contracts/results/#{params[:transactionIdOrHash]}/actions")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:transactionIdOrHash/opcodes
        def opcodes
          response = self.class.get("/api/v1/contracts/results/#{params[:transactionIdOrHash]}/opcodes")

          handle_response(response)
        end

        # GET /api/v1/contracts/{contractIdOrAddress}/results/logs
        def logs_by_contract
          response = self.class.get("/api/v1/contracts/#{params[:contractIdOrAddress]}/results/logs")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/logs
        def logs
          unless valid_query_params?(params, %w[contract_id timestamp limit order])
            return render json: { error: 'Invalid query parameters' }, status: :bad_request
          end

          response = self.class.get('/api/v1/contracts/results/logs', query: filtered_params(params))

          handle_response(response)
        end

        private

        # Validate query parameters for the contracts results endpoints
        def valid_query_params?(params, allowed_params)
          params.keys.all? { |key| allowed_params.include?(key) }
        end

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:contract_id, :timestamp, :limit, :order)
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
