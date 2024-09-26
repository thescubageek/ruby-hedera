# frozen_string_literal: true

require 'test_helper'

class Api::V1::SchedulesControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SchedulesController.new
    @schedule_id = '0.0.12345'
    @transaction_id = '0.0.67890'
    @executed = true
    @limit = 10
    @order = 'asc'
  end

  # Test for GET /api/v1/:network/schedules for each environment
  Api::V1::ApplicationController::BASE_URIS.each_key do |network|
    test "should get schedules index for #{network}" do
      # Simulate a response from HTTParty
      HTTParty.stub :get, success_response([{ schedule_id: @schedule_id, executed: @executed }].to_json) do
        get :index, params: { network: network, schedule_id: @schedule_id, transaction_id: @transaction_id, executed: @executed, limit: @limit, order: @order }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @schedule_id, body.first['schedule_id']
        assert_equal @executed, body.first['executed']
      end
    end

    # Test for GET /api/v1/:network/schedules/:schedule_id
    test "should get schedules show for #{network}" do
      HTTParty.stub :get, success_response({ schedule_id: @schedule_id, executed: @executed }.to_json) do
        get :show, params: { network: network, schedule_id: @schedule_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @schedule_id, body['schedule_id']
      end
    end

    # Test for GET /api/v1/:network/schedules/:schedule_id/transactions
    test "should get schedules transactions for #{network}" do
      HTTParty.stub :get, success_response([{ transaction_id: @transaction_id, schedule_id: @schedule_id }].to_json) do
        get :transactions, params: { network: network, schedule_id: @schedule_id }

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal @transaction_id, body.first['transaction_id']
        assert_equal @schedule_id, body.first['schedule_id']
      end
    end
  end

  # Helper method to simulate a successful HTTParty response
  private

  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
