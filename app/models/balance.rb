# frozen_string_literal: true

class Balance < HederaBase
  attr_accessor :account_id, :timestamp, :limit, :order

  def initialize(account_id: nil, timestamp: nil, limit: nil, order: nil, network: 'main')
    @account_id = account_id
    @timestamp = timestamp
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch all balances with query parameters
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/balances", query: query_params)
    handle_response(response)
  end

  def fetch
    self.class.all(query_params: { account_id: account_id, timestamp: timestamp, limit: limit, order: order }, network: network)
  end

end
