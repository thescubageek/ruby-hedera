# frozen_string_literal: true

require 'test_helper'

class Api::V1::NetworksControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::NetworksController.new
    @node_id = '0.0.12345'
    @account_id = '0.0.54321'
    @start_time = '2021-01-01T00:00:00Z'
    @end_time = '2021-12-31T23:59:59Z'
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/network/nodes for each environment
  Api::V1::ApplicationController::BASE_URIS.each_key do |network|
    test "should get network nodes for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ node_id: @node_id }].to_json) do
        get :nodes, params: { network: network, node_id: @node_id, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @node_id, body.first['node_id']
      end
    end

    # Test for GET /api/v1/:network/network/stake
    test "should get network stake for #{network}" do
      HTTParty.stub :get, success_response([{ account_id: @account_id, node_id: @node_id, stake: 1000 }].to_json) do
        get :stake, params: { network: network, account_id: @account_id, node_id: @node_id, start_time: @start_time, end_time: @end_time }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
        assert_equal @node_id, body.first['node_id']
      end
    end

    # Test for GET /api/v1/:network/network/supply
    test "should get network supply for #{network}" do
      HTTParty.stub :get, success_response({ total_supply: 50000000 }.to_json) do
        get :supply, params: { network: network }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 50000000, body['total_supply']
      end
    end

    # Test for GET /api/v1/:network/network/fees
    test "should get network fees for #{network}" do
      HTTParty.stub :get, success_response({ transaction_fees: '0.0001' }.to_json) do
        get :fees, params: { network: network }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal '0.0001', body['transaction_fees']
      end
    end

    # Test for GET /api/v1/:network/network/exchangerate
    test "should get network exchangerate for #{network}" do
      HTTParty.stub :get, success_response({ current_rate: '0.25' }.to_json) do
        get :exchangerate, params: { network: network }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal '0.25', body['current_rate']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
