# frozen_string_literal: true

class Account < HederaBase
  attr_accessor :account_id

  def initialize(account_id: nil, network: 'main')
    @account_id = account_id
    raise 'Account ID is required' unless account_id

    super(network: network)
  end

  # Class method to fetch all accounts
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/accounts", query: query_params)
    handle_response(response)&.[]('accounts')
  end

  # Instance method to fetch a specific account by ID
  def fetch
    response = self.class.get("/accounts/#{account_id}")
    self.class.handle_response(response)
  end

  # Fetch NFTs for the account
  def nfts
    query_params = { account_id: account_id, serial_number: serial_number, token_id: token_id }.compact
    response = self.class.get("/accounts/#{account_id}/nfts", query: query_params)
    self.class.handle_response(response)
  end

  # Fetch rewards for the account
  def rewards
    query_params = { account_id: account_id, start_time: start_time, end_time: end_time }.compact
    response = self.class.get("/accounts/#{account_id}/rewards", query: query_params)
    self.class.handle_response(response)
  end

  # Fetch tokens associated with the account
  def tokens
    query_params = { token_id: token_id }.compact
    response = self.class.get("/accounts/#{account_id}/tokens", query: query_params)
    self.class.handle_response(response)
  end

end
