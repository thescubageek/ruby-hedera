# frozen_string_literal: true

class Block < HederaBase
  attr_accessor :id, :data

  def initialize(id: nil, network: 'main')
    @id = id
    @data = nil
    super(network: network)
  end

  # Class method to fetch all blocks
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/blocks", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific block by ID
  def fetch
    raise 'Block ID is required' unless id

    response = self.class.get("/blocks/#{id}")
    self.class.handle_response(response)
  end

end
