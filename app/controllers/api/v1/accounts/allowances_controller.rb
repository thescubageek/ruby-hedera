# frozen_string_literal: true

require 'test_helper'

# app/controllers/api/v1/accounts/allowances_controller.rb
module Api
  module V1
    module Accounts
      class AllowancesController < Api::V1::ApplicationController
        # GET /api/v1/accounts/:account_id/allowances
        def index
          account_id = params.require(:account_id)
          response = self.class.get("/api/v1/accounts/#{account_id}/allowances")

          handle_response(response)
        end

        # GET /api/v1/accounts/:account_id/allowances/:allowance_id
        def show
          account_id = params.require(:account_id)
          allowance_id = params.require(:allowance_id)
          response = self.class.get("/api/v1/accounts/#{account_id}/allowances/#{allowance_id}")

          handle_response(response)
        end
      end
    end
  end
end
