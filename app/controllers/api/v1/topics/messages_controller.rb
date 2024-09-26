# app/controllers/api/v1/topics/messages_controller.rb
module Api
  module V1
    module Topics
      class MessagesController < Api::V1::ApplicationController
        include HTTParty
        base_uri 'https://mainnet-public.mirrornode.hedera.com'

        # GET /api/v1/topics/:topic_id/messages
        def index
          unless valid_query_params?(params, %w[limit order sequence_number timestamp])
            return render json: { error: 'Invalid query parameters' }, status: :bad_request
          end

          response = self.class.get("/api/v1/topics/#{params[:topic_id]}/messages", query: filtered_params(params))

          handle_response(response)
        end

        # GET /api/v1/topics/:topic_id/messages/:sequence_number
        def show
          response = self.class.get("/api/v1/topics/#{params[:topic_id]}/messages/#{params[:sequence_number]}")

          handle_response(response)
        end

        private

        # Validate query parameters for the messages endpoints
        def valid_query_params?(params, allowed_params)
          params.keys.all? { |key| allowed_params.include?(key) }
        end

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:limit, :order, :sequence_number, :timestamp)
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
