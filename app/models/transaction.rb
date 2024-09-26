# frozen_string_literal: true

class Transaction < HederaBase
  attr_accessor :transaction_id, :account_id, :result, :type, :timestamp, :limit, :order, :data

  def initialize(transaction_id: nil, account_id: nil, result: nil, type: nil, timestamp: nil, limit: nil, order: nil, network: 'main')
    @transaction_id = transaction_id
    @account_id = account_id
    @result = result
    @type = type
    @timestamp = timestamp
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch all transactions
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/transactions", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific transaction by ID
  def fetch
    raise 'Transaction ID is required' unless transaction_id

    response = self.class.get("/transactions/#{transaction_id}")
    self.class.handle_response(response)
  end

  # Fetch records for a specific transaction
  def records
    raise 'Transaction ID is required' unless transaction_id

    response = self.class.get("/transactions/#{transaction_id}/records")
    self.class.handle_response(response)
  end

end
