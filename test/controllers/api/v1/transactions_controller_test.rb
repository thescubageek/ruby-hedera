# frozen_string_literal: true

require 'test_helper'

class Api::V1::TransactionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::TransactionsController.new
    @transaction_id = '0.0.12345'
    @account_id = '0.0.54321'
    @result = 'success'
    @type = 'transfer'
    @timestamp = '2021-01-01T00:00:00Z'
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/transactions for each environment
  Api::V1::ApplicationController::BASE_URIS.each do |network|
    test "should get transactions index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ transaction_id: @transaction_id, account_id: @account_id, result: @result }].to_json) do
        get :index, params: { network: network, transaction_id: @transaction_id, account_id: @account_id, result: @result, type: @type, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @transaction_id, body.first['transaction_id']
        assert_equal @account_id, body.first['account_id']
        assert_equal @result, body.first['result']
      end
    end

    # Test for GET /api/v1/:network/transactions/:transaction_id
    test "should get transactions show for #{network}" do
      HTTParty.stub :get, success_response({ transaction_id: @transaction_id, account_id: @account_id, result: @result }.to_json) do
        get :show, params: { network: network, transaction_id: @transaction_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @transaction_id, body['transaction_id']
        assert_equal @account_id, body['account_id']
        assert_equal @result, body['result']
      end
    end

    # Test for GET /api/v1/:network/transactions/:transaction_id/records
    test "should get transactions records for #{network}" do
      HTTParty.stub :get, success_response([{ record: 'some record data', transaction_id: @transaction_id }].to_json) do
        get :records, params: { network: network, transaction_id: @transaction_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @transaction_id, body.first['transaction_id']
        assert_equal 'some record data', body.first['record']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
