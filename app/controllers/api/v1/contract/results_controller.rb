# app/controllers/api/v1/contracts/results_controller.rb
module Api
  module V1
    module Contracts
      class ResultsController < Api::V1::ApplicationController

        # GET /api/v1/contracts/results
        def index
          return unless valid_query_params?(params, %w[contract_id timestamp limit order])

          response = self.class.get('/api/v1/contracts/results', query: filtered_params(params))

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:id
        def show
          response = self.class.get("/api/v1/contracts/results/#{params.require(:id)}")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:transactionIdOrHash/actions
        def actions
          response = self.class.get("/api/v1/contracts/results/#{params.require(:transactionIdOrHash)}/actions")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/:transactionIdOrHash/opcodes
        def opcodes
          response = self.class.get("/api/v1/contracts/results/#{params.require(:transactionIdOrHash)}/opcodes")

          handle_response(response)
        end

        # GET /api/v1/contracts/{contractIdOrAddress}/results/logs
        def logs_by_contract
          response = self.class.get("/api/v1/contracts/#{params.require(:contractIdOrAddress)}/results/logs")

          handle_response(response)
        end

        # GET /api/v1/contracts/results/logs
        def logs
          return unless valid_query_params?(params, %w[contract_id timestamp limit order])

          response = self.class.get('/api/v1/contracts/results/logs', query: filtered_params(params))

          handle_response(response)
        end

        private

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:contract_id, :timestamp, :limit, :order)
        end
      end
    end
  end
end
