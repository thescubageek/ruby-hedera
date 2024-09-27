# frozen_string_literal: true

# app/controllers/application_controller.rb

module Api
  module V1
    class ApplicationController < ActionController::API
      private

      # Common method to handle results from Hedera API calls
      def handle_result(result)
        if result.success?
          render json: result.data, status: result.status
        else
          error_message = result.errors.first&.[]('message') || 'Unknown Error'
          render json: { error: "Hedera API Error: #{error_message}", code: result.code }, status: result.code
        end
      end

      # Validate query parameters for any endpoint
      def valid_query_params?(params, allowed_params)
        unless params.keys.all? { |key| allowed_params.include?(key) }
          render json: { error: 'Invalid query parameters' }, status: :bad_request
          return false
        end
        true
      end

      # Common headers for POST requests
      def headers(custom_headers = {})
        { 'Content-Type' => 'application/json' }.merge(custom_headers)
      end
    end
  end
end
