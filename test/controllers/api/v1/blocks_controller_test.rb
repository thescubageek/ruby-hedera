# frozen_string_literal: true

require 'test_helper'

class Api::V1::BlocksControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::BlocksController.new
    @block_id = '12345'
  end

  # Test for GET /api/v1/:network/blocks for each environment
  Api::V1::ApplicationController::BASE_URIS.each do |network|
    test "should get index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ block_id: @block_id, timestamp: '2021-01-01T00:00:00Z' }].to_json) do
        get :index, params: { network: network }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @block_id, body.first['block_id']
      end
    end

    # Test for GET /api/v1/:network/blocks/:id
    test "should get show for #{network}" do
      HTTParty.stub :get, success_response({ block_id: @block_id, timestamp: '2021-01-01T00:00:00Z' }.to_json) do
        get :show, params: { network: network, id: @block_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @block_id, body['block_id']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
