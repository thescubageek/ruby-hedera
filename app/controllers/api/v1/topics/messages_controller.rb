# app/controllers/api/v1/topics/messages_controller.rb
module Api
  module V1
    module Topics
      class MessagesController < Api::V1::ApplicationController

        # GET /api/v1/topics/:topic_id/messages
        def index
          return unless valid_query_params?(params, %w[limit order sequence_number timestamp])

          response = self.class.get("/api/v1/topics/#{params[:topic_id]}/messages", query: filtered_params(params))

          handle_response(response)
        end

        # GET /api/v1/topics/:topic_id/messages/:sequence_number
        def show
          response = self.class.get("/api/v1/topics/#{params[:topic_id]}/messages/#{params[:sequence_number]}")

          handle_response(response)
        end

        private

        # Filter valid query params to send to Hedera API
        def filtered_params(params)
          params.permit(:limit, :order, :sequence_number, :timestamp)
        end
      end
    end
  end
end
