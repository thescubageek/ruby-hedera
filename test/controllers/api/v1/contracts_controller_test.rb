# frozen_string_literal: true

require 'test_helper'

class Api::V1::ContactsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::ContactsController.new
    @contract_id = '0.0.12345'
    @timestamp = '2021-01-01T00:00:00Z'
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/contracts for each environment
  HederaBase::BASE_URIS.each_key do |network|
    test "should get contracts index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ contract_id: @contract_id, timestamp: @timestamp }].to_json) do
        get :index, params: { network: network, contract_id: @contract_id, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body.first['contract_id']
        assert_equal @timestamp, body.first['timestamp']
      end
    end

    # Test for GET /api/v1/:network/contracts/:id
    test "should get contracts show for #{network}" do
      HTTParty.stub :get, success_response({ contract_id: @contract_id, timestamp: @timestamp }.to_json) do
        get :show, params: { network: network, id: @contract_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body['contract_id']
      end
    end

    # Test for GET /api/v1/:network/contracts/:id/results
    test "should get contracts results for #{network}" do
      HTTParty.stub :get, success_response([{ result: 'some result data', contract_id: @contract_id }].to_json) do
        get :results, params: { network: network, id: @contract_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body.first['contract_id']
        assert_equal 'some result data', body.first['result']
      end
    end

    # Test for GET /api/v1/:network/contracts/:id/logs
    test "should get contracts logs for #{network}" do
      HTTParty.stub :get, success_response([{ log: 'some log data', contract_id: @contract_id }].to_json) do
        get :logs, params: { network: network, id: @contract_id, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body.first['contract_id']
        assert_equal 'some log data', body.first['log']
      end
    end

    # Test for GET /api/v1/:network/contracts/:id/state
    test "should get contracts state for #{network}" do
      HTTParty.stub :get, success_response({ state: 'some state data', contract_id: @contract_id }.to_json) do
        get :state, params: { network: network, id: @contract_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body['contract_id']
        assert_equal 'some state data', body['state']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
