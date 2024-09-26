# frozen_string_literal: true

class Token < HederaBase
  attr_accessor :token_id, :limit, :order, :account_id, :balance, :serial_number, :data

  def initialize(token_id: nil, limit: nil, order: nil, account_id: nil, balance: nil, serial_number: nil, network: 'main')
    @token_id = token_id
    @limit = limit
    @order = order
    @account_id = account_id
    @balance = balance
    @serial_number = serial_number
    @data = nil
    super(network: network)
  end

  # Class method to fetch all tokens
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/tokens", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific token by ID
  def fetch
    raise 'Token ID is required' unless token_id

    response = self.class.get("/tokens/#{token_id}")
    self.class.handle_response(response)
  end

  # Fetch token balances
  def balances
    raise 'Token ID is required' unless token_id

    query_params = { limit: limit, order: order, account_id: account_id, balance: balance }.compact
    response = self.class.get("/tokens/#{token_id}/balances", query: query_params)
    self.class.handle_response(response)
  end

  # Fetch token NFTs
  def nfts
    raise 'Token ID is required' unless token_id

    query_params = { limit: limit, order: order, serial_number: serial_number }.compact
    response = self.class.get("/tokens/#{token_id}/nfts", query: query_params)
    self.class.handle_response(response)
  end

  # Memoize data so it can be referenced on the model without fetching again
  def data
    @data ||= fetch
  end
end
