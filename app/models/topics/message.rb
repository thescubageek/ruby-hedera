# frozen_string_literal: true

class Topics::Message < HederaBase
  attr_accessor :topic_id, :limit, :order, :sequence_number, :timestamp

  def initialize(topic_id: nil, limit: nil, order: nil, sequence_number: nil, timestamp: nil, network: 'main')
    @topic_id = topic_id
    raise 'Topic ID is required' unless topic_id

    @limit = limit
    @order = order
    @sequence_number = sequence_number
    @timestamp = timestamp
    @data = nil
    super(network: network)
  end

  # Fetch all messages for a topic
  def self.all
    query_params = { limit: limit, order: order, sequence_number: sequence_number, timestamp: timestamp }.compact
    response = self.get("#{BASE_URIS[network]}/topics/#{topic_id}/messages", query: query_params)
    self.class.handle_response(response)
  end

  # Fetch a specific message by sequence number
  def fetch(sequence_number)
    raise 'Sequence number is required' unless sequence_number

    response = self.class.get("/topics/#{topic_id}/messages/#{sequence_number}")
    self.class.handle_response(response)
  end

end
