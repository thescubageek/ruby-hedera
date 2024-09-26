# frozen_string_literal: true

require 'test_helper'

class Api::V1::TokensControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::TokensController.new
    @token_id = '0.0.12345'
    @account_id = '0.0.54321'
    @balance = 1000
    @serial_number = 1
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/tokens for each environment
  Api::V1::ApplicationController::BASE_URIS.each_key do |network|
    test "should get tokens index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ token_id: @token_id, balance: @balance }].to_json) do
        get :index, params: { network: network, token_id: @token_id, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @token_id, body.first['token_id']
        assert_equal @balance, body.first['balance']
      end
    end

    # Test for GET /api/v1/:network/tokens/:token_id
    test "should get tokens show for #{network}" do
      HTTParty.stub :get, success_response({ token_id: @token_id, balance: @balance }.to_json) do
        get :show, params: { network: network, token_id: @token_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @token_id, body['token_id']
        assert_equal @balance, body['balance']
      end
    end

    # Test for GET /api/v1/:network/tokens/:token_id/balances
    test "should get tokens balances for #{network}" do
      HTTParty.stub :get, success_response([{ account_id: @account_id, balance: @balance }].to_json) do
        get :balances, params: { network: network, token_id: @token_id, limit: @limit, order: @order, account_id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
        assert_equal @balance, body.first['balance']
      end
    end

    # Test for GET /api/v1/:network/tokens/:token_id/nfts
    test "should get tokens nfts for #{network}" do
      HTTParty.stub :get, success_response([{ serial_number: @serial_number, token_id: @token_id }].to_json) do
        get :nfts, params: { network: network, token_id: @token_id, limit: @limit, order: @order, serial_number: @serial_number }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @serial_number, body.first['serial_number']
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
