# app/controllers/api/v1/contacts_controller.rb
module Api
  module V1
    class ContactsController < Api::V1::ApplicationController

      # GET /api/v1/contracts
      def index
        return unless valid_query_params?(params, %w[contract_id timestamp limit order])

        response = self.class.get('/api/v1/contracts', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/contracts/:id
      def show
        response = self.class.get("/api/v1/contracts/#{params.require(:id)}")
        handle_response(response)
      end

      # GET /api/v1/contracts/:id/results
      def results
        response = self.class.get("/api/v1/contracts/#{params.require(:id)}/results")
        handle_response(response)
      end

      # GET /api/v1/contracts/:id/logs
      def logs
        return unless valid_query_params?(params, %w[contract_id timestamp limit order])

        response = self.class.get("/api/v1/contracts/#{params.require(:id)}/logs", query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/contracts/:id/state
      def state
        response = self.class.get("/api/v1/contracts/#{params.require(:id)}/state")
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
