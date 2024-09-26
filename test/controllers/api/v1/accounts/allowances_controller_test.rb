# frozen_string_literal: true

require 'test_helper'

class Api::V1::Accounts::AllowancesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::Accounts::AllowancesController.new
    @account_id = '0.0.12345'
    @allowance_id = 'allowance_56789'
  end

  # Test for GET /api/v1/:network/accounts/:account_id/allowances for each environment
  Api::V1::ApplicationController::BASE_URIS.each do |network|
    test "should get allowances index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ account_id: @account_id, allowance_id: @allowance_id }].to_json) do
        get :index, params: { network: network, account_id: @account_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body.first['account_id']
        assert_equal @allowance_id, body.first['allowance_id']
      end
    end

    # Test for GET /api/v1/:network/accounts/:account_id/allowances/:allowance_id
    test "should get allowances show for #{network}" do
      HTTParty.stub :get, success_response({ account_id: @account_id, allowance_id: @allowance_id }.to_json) do
        get :show, params: { network: network, account_id: @account_id, allowance_id: @allowance_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @account_id, body['account_id']
        assert_equal @allowance_id, body['allowance_id']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
