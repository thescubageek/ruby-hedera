# frozen_string_literal: true

require 'active_model'
require 'httparty'

class HederaBase
  include ActiveModel::Model
  include HTTParty

  MAINNET_BASE_URI = 'https://mainnet.mirrornode.hedera.com/api/v1'
  TESTNET_BASE_URI = 'https://testnet.mirrornode.hedera.com/api/v1'
  PREVIEWNET_BASE_URI = 'https://previewnet.mirrornode.hedera.com/api/v1'

  BASE_URIS = {
    'main'    => MAINNET_BASE_URI,
    'test'    => TESTNET_BASE_URI,
    'preview' => PREVIEWNET_BASE_URI
  }.freeze

  attr_accessor :network

  def initialize(network: 'main')
    @data = nil
    @network = network
    validate_network!

    self.class.base_uri BASE_URIS[network]
  end

  def self.validate_network!(network)
    raise 'Invalid network' unless network.in?(BASE_URIS)
  end

  def validate_network!
    self.class.validate_network!(network)
  end

  # Memoize data so it can be referenced on the model without fetching again
  def data
    @data ||= fetch if respond_to?(:fetch)
  end

  # Fall back to data if method is not defined
  def method_missing(m, *args, &block)
    data&.key?(m.to_s) ? data[m.to_s] : super
  rescue StandardError => _e
    super
  end

  # Fallback to data if method is missings
  def respond_to_missing?(method_name, include_private = false)
    data.key?(method_name.to_s) || super
  end

  # Helper method to handle the response
  def self.handle_response(response)
    if response.success?
      Result.new_success(data: response.parsed_response, status: response.code)
    else
      Result.new_failure(errors: [response.message], status: response.code)
    end
  end
end
