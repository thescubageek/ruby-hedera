# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class AccountsControllerTest < ActionDispatch::IntegrationTest
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
      # HederaBase::BASE_URIS.each_key do |network|

      network = 'main'
        test "should get index for #{network}" do
          # Simulate a response from HTTParty
          HTTParty.stub :get, success_response([{ account_id: @account_id, public_key: @public_key, balance: 1000 }].to_json) do
            get api_v1_accounts_url(network: network)

            assert_response :success
            body = response.parsed_body
            assert_equal @account_id, body.first['account_id']
          end
        end

        # # Test for GET /api/v1/:network/accounts/:id
        # test "should get show for #{network}" do
        #   HTTParty.stub :get, success_response({ account_id: @account_id, public_key: @public_key, balance: 1000 }.to_json) do
        #     get api_v1_account_url(network: network, id: @account_id)

        #     assert_response :success
        #     body = response.parsed_body
        #     assert_equal @account_id, body['account_id']
        #   end
        # end

        # # Test for GET /api/v1/:network/accounts/:id/nfts
        # test "should get nfts for #{network}" do
        #   HTTParty.stub :get, success_response([{ serial_number: @serial_number, token_id: @token_id }].to_json) do
        #     get nfts_api_v1_account_url(network: network, id: @account_id)

        #     assert_response :success
        #     body = response.parsed_body
        #     assert_equal @serial_number, body.first['serial_number']
        #   end
        # end

        # # Test for GET /api/v1/:network/accounts/:id/rewards
        # test "should get rewards for #{network}" do
        #   HTTParty.stub :get, success_response([{ account_id: @account_id, reward: 100 }].to_json) do
        #     get rewards_api_v1_account_url(network: network, id: @account_id), query_params: { start_time: @start_time, end_time: @end_time }

        #     assert_response :success
        #     body = response.parsed_body
        #     assert_equal @account_id, body.first['account_id']
        #   end
        # end

        # # Test for GET /api/v1/:network/accounts/:id/tokens
        # test "should get tokens for #{network}" do
        #   HTTParty.stub :get, success_response([{ token_id: @token_id }].to_json) do
        #     get tokens_api_v1_account_url(network: network, id: @account_id)

        #     assert_response :success
        #     body = response.parsed_body
        #     assert_equal @token_id, body.first['token_id']
        #   end
        # end
      # end
    end
  end
end
