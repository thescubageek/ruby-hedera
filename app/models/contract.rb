# frozen_string_literal: true

class Contract < HederaBase
  attr_accessor :contract_id, :timestamp, :limit, :order

  def initialize(contract_id: nil, timestamp: nil, limit: nil, order: nil, network: 'main')
    @contract_id = contract_id
    raise 'Contract ID is required' unless contract_id

    @timestamp = timestamp
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch all contracts
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/contracts", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific contract by ID
  def fetch
    response = self.class.get("/contracts/#{contract_id}")
    self.class.handle_response(response)
  end

  # Fetch results for the contract
  def results
    response = self.class.get("/contracts/#{contract_id}/results")
    self.class.handle_response(response)
  end

  # Fetch logs for the contract
  def logs
    query_params = { contract_id: contract_id, timestamp: timestamp, limit: limit, order: order }.compact
    response = self.class.get("/contracts/#{contract_id}/logs", query: query_params)
    self.class.handle_response(response)
  end

  # Fetch state for the contract
  def state
    response = self.class.get("/contracts/#{contract_id}/state")
    self.class.handle_response(response)
  end

end
