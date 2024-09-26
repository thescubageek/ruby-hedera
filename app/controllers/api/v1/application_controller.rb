# app/controllers/application_controller.rb
class Api::V1::ApplicationController < ActionController::API
  include HTTParty
  base_uri 'https://mainnet-public.mirrornode.hedera.com'

  # Common method to handle responses from Hedera API and return appropriate status
  def handle_response(response, success_status = :ok)
    if response.code == 200 || response.code == success_status
      render json: response.parsed_response, status: success_status
    else
      error_message = response.parsed_response['message'] || 'Unknown Error'
      render json: { error: "Hedera API Error: #{error_message}", code: response.code }, status: response.code
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
