# frozen_string_literal: true

class HederaBase
  include ActiveModel::Model
  include HTTParty

  BASE_URIS = Api::V1::ApplicationController::BASE_URIS.freeze

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

  private

  # Helper method to handle the response
  def self.handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      { error: response.message }
    end
  end
end
