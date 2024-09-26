# frozen_string_literal: true

class Token::Nft < HederaBase
  attr_accessor :token_id, :serial_number, :limit, :order, :data

  def initialize(token_id: nil, serial_number: nil, limit: nil, order: nil, network: 'main')
    @token_id = token_id
    raise 'Token ID is required' unless token_id

    @serial_number = serial_number
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch all NFTs for a token
  def self.all(token_id:, query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/tokens/#{token_id}/nfts", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific NFT by serial number
  def fetch
    raise 'Serial number is required' unless serial_number

    response = self.class.get("/tokens/#{token_id}/nfts/#{serial_number}")
    self.class.handle_response(response)
  end

  # Fetch transactions for a specific NFT
  def transactions
    raise 'Serial number is required' unless serial_number

    response = self.class.get("/tokens/#{token_id}/nfts/#{serial_number}/transactions")
    self.class.handle_response(response)
  end

end
