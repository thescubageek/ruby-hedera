# frozen_string_literal: true

class Topic < HederaBase
  attr_accessor :topic_id, :data

  def initialize(topic_id: nil, network: 'main')
    @topic_id = topic_id
    raise 'Topic ID is required' unless topic_id

    @data = nil
    super(network: network)
  end

  # Instance method to fetch a specific topic by ID
  def fetch
    response = self.class.get("/topics/#{topic_id}")
    self.class.handle_response(response)
  end

  # Memoize data so it can be referenced on the model without fetching again
  def data
    @data ||= fetch
  end
end
