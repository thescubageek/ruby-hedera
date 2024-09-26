# frozen_string_literal: true

require 'test_helper'

class Api::V1::ApplicationControllerTest < ActionController::TestCase
  # Stub HTTParty base_uri method
  class StubbedApiController < Api::V1::ApplicationController
    def set_base_uri
      super
      HTTParty.base_uri
    end
  end

  tests StubbedApiController

  def setup
    @controller = StubbedApiController.new
  end

  test 'should set base_uri to mainnet for /main network' do
    get :set_base_uri, params: { network: 'main' }

    assert_equal 'https://mainnet.mirrornode.hedera.com/api/v1', HTTParty.base_uri
  end

  test 'should set base_uri to testnet for /test network' do
    get :set_base_uri, params: { network: 'test' }

    assert_equal 'https://testnet.mirrornode.hedera.com/api/v1', HTTParty.base_uri
  end

  test 'should set base_uri to previewnet for /preview network' do
    get :set_base_uri, params: { network: 'preview' }

    assert_equal 'https://previewnet.mirrornode.hedera.com/api/v1', HTTParty.base_uri
  end

  test 'should return 400 for invalid network' do
    get :set_base_uri, params: { network: 'invalid' }

    assert_response :bad_request
    assert_equal({ 'error' => 'Invalid network specified' }.to_json, @response.body)
  end
end
