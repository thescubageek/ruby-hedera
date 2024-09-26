# frozen_string_literal: true

class Accounts::Allowance < HederaBase
  attr_accessor :account_id, :allowance_id

  def initialize(account_id: nil, allowance_id: nil, network: 'main')
    @account_id = account_id
    raise 'Account ID is required' unless account_id

    @allowance_id = allowance_id
    @data = nil
    super(network: network)
  end

  # Class method to fetch all allowances for an account
  def self.all(account_id:, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/accounts/#{account_id}/allowances")
    handle_response(response)
  end

  # Instance method to fetch a specific allowance by ID
  def fetch
    response = self.class.get("/accounts/#{account_id}/allowances/#{allowance_id}")
    self.class.handle_response(response)
  end

end
