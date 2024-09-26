# frozen_string_literal: true

class Schedule < HederaBase
  attr_accessor :schedule_id, :transaction_id, :executed, :limit, :order, :data

  def initialize(schedule_id: nil, transaction_id: nil, executed: nil, limit: nil, order: nil, network: 'main')
    @schedule_id = schedule_id
    raise 'Schedule ID is required' unless schedule_id

    @transaction_id = transaction_id
    @executed = executed
    @limit = limit
    @order = order
    @data = nil
    super(network: network)
  end

  # Class method to fetch all schedules
  def self.all(query_params: {}, network: 'main')
    validate_network!(network)

    response = get("#{BASE_URIS[network]}/schedules", query: query_params)
    handle_response(response)
  end

  # Instance method to fetch a specific schedule by ID
  def fetch
    response = self.class.get("/schedules/#{schedule_id}")
    self.class.handle_response(response)
  end

  # Fetch transactions for the schedule
  def transactions
    response = self.class.get("/schedules/#{schedule_id}/transactions")
    self.class.handle_response(response)
  end

end
