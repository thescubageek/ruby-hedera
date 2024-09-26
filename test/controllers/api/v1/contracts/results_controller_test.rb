# frozen_string_literal: true

require 'test_helper'

class Api::V1::Contracts::ResultsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::Contracts::ResultsController.new
    @contract_id = '0.0.12345'
    @transaction_id_or_hash = '0xabc123'
    @contract_id_or_address = '0.0.56789'
    @timestamp = '2021-01-01T00:00:00Z'
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/contracts/results for each environment
  Api::V1::ApplicationController::BASE_URIS.each do |network|
    test "should get contracts results index for #{network}" do
      HTTParty.stub :get, success_response([{ contract_id: @contract_id, timestamp: @timestamp }].to_json) do
        get :index, params: { network: network, contract_id: @contract_id, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body.first['contract_id']
        assert_equal @timestamp, body.first['timestamp']
      end
    end

    # Test for GET /api/v1/:network/contracts/results/:id
    test "should get contracts results show for #{network}" do
      HTTParty.stub :get, success_response({ contract_id: @contract_id, timestamp: @timestamp }.to_json) do
        get :show, params: { network: network, id: @contract_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @contract_id, body['contract_id']
        assert_equal @timestamp, body['timestamp']
      end
    end

    # Test for GET /api/v1/:network/contracts/results/:transactionIdOrHash/actions
    test "should get contracts results actions for #{network}" do
      HTTParty.stub :get, success_response([{ action: 'some action data', transactionIdOrHash: @transaction_id_or_hash }].to_json) do
        get :actions, params: { network: network, transactionIdOrHash: @transaction_id_or_hash }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 'some action data', body.first['action']
        assert_equal @transaction_id_or_hash, body.first['transactionIdOrHash']
      end
    end

    # Test for GET /api/v1/:network/contracts/results/:transactionIdOrHash/opcodes
    test "should get contracts results opcodes for #{network}" do
      HTTParty.stub :get, success_response([{ opcode: 'some opcode data', transactionIdOrHash: @transaction_id_or_hash }].to_json) do
        get :opcodes, params: { network: network, transactionIdOrHash: @transaction_id_or_hash }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 'some opcode data', body.first['opcode']
        assert_equal @transaction_id_or_hash, body.first['transactionIdOrHash']
      end
    end

    # Test for GET /api/v1/:network/contracts/:contractIdOrAddress/results/logs
    test "should get contracts logs by contract for #{network}" do
      HTTParty.stub :get, success_response([{ log: 'some log data', contractIdOrAddress: @contract_id_or_address }].to_json) do
        get :logs_by_contract, params: { network: network, contractIdOrAddress: @contract_id_or_address }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 'some log data', body.first['log']
        assert_equal @contract_id_or_address, body.first['contractIdOrAddress']
      end
    end

    # Test for GET /api/v1/:network/contracts/results/logs
    test "should get contracts logs for #{network}" do
      HTTParty.stub :get, success_response([{ log: 'some log data', contract_id: @contract_id }].to_json) do
        get :logs, params: { network: network, contract_id: @contract_id, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 'some log data', body.first['log']
        assert_equal @contract_id, body.first['contract_id']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
