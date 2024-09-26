# app/controllers/api/v1/schedules_controller.rb
module Api
  module V1
    class SchedulesController < Api::V1::ApplicationController

      # GET /api/v1/schedules
      def index
        return unless valid_query_params?(params, %w[schedule_id transaction_id executed limit order])

        response = self.class.get('/api/v1/schedules', query: filtered_params(params))
        handle_response(response)
      end

      # GET /api/v1/schedules/:schedule_id
      def show
        response = self.class.get("/api/v1/schedules/#{params.require(:schedule_id)}")
        handle_response(response)
      end

      # GET /api/v1/schedules/:schedule_id/transactions
      def transactions
        response = self.class.get("/api/v1/schedules/#{params.require(:schedule_id)}/transactions")
        handle_response(response)
      end

      private

      # Filter valid query params to send to Hedera API
      def filtered_params(params)
        params.permit(:schedule_id, :transaction_id, :executed, :limit, :order)
      end
    end
  end
end
