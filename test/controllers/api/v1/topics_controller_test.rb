# frozen_string_literal: true

require 'test_helper'

class Api::V1::TopicsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::TopicsController.new
    @topic_id = '0.0.12345'
  end

  # Test for GET /api/v1/:network/topics/:topic_id for each environment
  HederaBase::BASE_URIS.each_key do |network|
    test "should get topics show for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response({ topic_id: @topic_id, messages: ['message1', 'message2'] }.to_json) do
        get :show, params: { network: network, topic_id: @topic_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @topic_id, body['topic_id']
        assert_equal ['message1', 'message2'], body['messages']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
