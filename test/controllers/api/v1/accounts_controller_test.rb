# frozen_string_literal: true

require 'test_helper'

class Api::V1::AccountsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::AccountsController.new
    @account_id = '0.0.12345'
    @public_key = '302a300506032b6570032100d3c9e2f57d1a4447fa6bcbcb742bfb9d'
    @token_id = '0.0.56789'
    @serial_number = 123
    @start_time = '2021-01-01T00:00:00Z'
    @end_time = '2021-12-31T23:59:59Z'
  end

  # Test for GET /api/v1/:network/accounts for each environment
  Api::V1::ApplicationController::BASE_URIS.each do |network|
    test "should get index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ account_id: @account_id, public_key: @public_key, balance: 1000 }].to_json) do
        get :index, params: { network: network, account_id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
      end
    end

    # Test for GET /api/v1/:network/accounts/:id
    test "should get show for #{network}" do
      HTTParty.stub :get, success_response({ account_id: @account_id, public_key: @public_key, balance: 1000 }.to_json) do
        get :show, params: { network: network, id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body['account_id']
      end
    end

    # Test for GET /api/v1/:network/accounts/:id/nfts
    test "should get nfts for #{network}" do
      HTTParty.stub :get, success_response([{ serial_number: @serial_number, token_id: @token_id }].to_json) do
        get :nfts, params: { network: network, id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @serial_number, body.first['serial_number']
      end
    end

    # Test for GET /api/v1/:network/accounts/:id/rewards
    test "should get rewards for #{network}" do
      HTTParty.stub :get, success_response([{ account_id: @account_id, reward: 100 }].to_json) do
        get :rewards, params: { network: network, id: @account_id, start_time: @start_time, end_time: @end_time }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
      end
    end

    # Test for GET /api/v1/:network/accounts/:id/tokens
    test "should get tokens for #{network}" do
      HTTParty.stub :get, success_response([{ token_id: @token_id }].to_json) do
        get :tokens, params: { network: network, id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @token_id, body.first['token_id']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
