# frozen_string_literal: true

class Block
  include ActiveModel::Model
  include HTTParty

  attr_accessor :id, :network

  def initialize(id: nil, network: 'main')
    raise 'Invalid network' unless network.in?(Api::V1::ApplicationController::BASE_URIS)
    
    @network = network
    @id = id
    self.class.base_uri BASE_URIS[network]
  end

  # Class method to fetch all blocks
  def self.all(query_params: {}, network: 'main')
    response = get('/blocks', query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific block by ID
  def fetch
    raise 'Block ID is required' unless id

    response = self.class.get("/blocks/#{id}")
    handle_response(response)
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
