# frozen_string_literal: true

class Contract::Result < HederaBase
  attr_accessor :contract_id, :timestamp, :limit, :order, :transaction_id_or_hash, :data

  def initialize(contract_id: nil, timestamp: nil, limit: nil, order: nil, transaction_id_or_hash: nil, network: 'main')
    @contract_id = contract_id
    @timestamp = timestamp
    @limit = limit
    @order = order
    @transaction_id_or_hash = transaction_id_or_hash
    @data = nil
    super(network: network)
  end

  # Class method to fetch all contract results
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/contracts/results", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific contract result by ID
  def fetch
    raise 'Contract ID is required' unless contract_id

    response = self.class.get("/contracts/results/#{contract_id}")
    self.class.handle_response(response)
  end

  # Fetch actions for a specific transaction
  def actions
    raise 'Transaction ID or Hash is required' unless transaction_id_or_hash

    response = self.class.get("/contracts/results/#{transaction_id_or_hash}/actions")
    self.class.handle_response(response)
  end

  # Fetch opcodes for a specific transaction
  def opcodes
    raise 'Transaction ID or Hash is required' unless transaction_id_or_hash

    response = self.class.get("/contracts/results/#{transaction_id_or_hash}/opcodes")
    self.class.handle_response(response)
  end

  # Fetch logs for a specific contract
  def logs_by_contract
    raise 'Contract ID is required' unless contract_id

    response = self.class.get("/contracts/#{contract_id}/results/logs")
    self.class.handle_response(response)
  end

  # Fetch logs for contract results
  def logs(query_params: {})
    response = self.class.get('/contracts/results/logs', query: query_params)
    self.class.handle_response(response)
  end

end
