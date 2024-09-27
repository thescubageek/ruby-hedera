# frozen_string_literal: true

require 'test_helper'

class Api::V1::BalancesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::BalancesController.new
    @account_id = '0.0.12345'
    @timestamp = '2021-01-01T00:00:00Z'
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/balances for each environment
  HederaBase::BASE_URIS.each_key do |network|
    test "should get balances index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ account_id: @account_id, balance: 1000, timestamp: @timestamp }].to_json) do
        get :index, params: { network: network, account_id: @account_id, timestamp: @timestamp, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
        assert_equal @timestamp, body.first['timestamp']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
