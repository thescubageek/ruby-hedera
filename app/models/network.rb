# frozen_string_literal: true

class Network < HederaBase
  attr_accessor :node_id, :account_id, :start_time, :end_time, :limit, :order, :data

  def initialize(node_id: nil, account_id: nil, start_time: nil, end_time: nil, limit: nil, order: nil, network: 'main')
    @node_id = node_id
    @account_id = account_id
    @start_time = start_time
    @end_time = end_time
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch nodes
  def self.nodes(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/network/nodes", query: query_params)
    handle_response(response)
  end

  # Class method to fetch stake data
  def self.stake(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/network/stake", query: query_params)
    handle_response(response)
  end

  # Class method to fetch supply data
  def self.supply(network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/network/supply")
    handle_response(response)
  end

  # Class method to fetch fee data
  def self.fees(network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/network/fees")
    handle_response(response)
  end

  # Class method to fetch exchange rate data
  def self.exchangerate(network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/network/exchangerate")
    handle_response(response)
  end

end
