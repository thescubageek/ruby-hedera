# app/controllers/api/v1/accounts_controller.rb
module Api
  module V1
    class AccountsController < Api::V1::ApplicationController
      # GET /api/v1/accounts
      def index
        return unless valid_query_params?(params, %w[account_id public_key balance])

        result = Account.all(network:, query_params: filtered_params(params))
        handle_result(result)
      end

      # GET /api/v1/accounts/:id
      def show
        result = account.fetch
        handle_result(result)
      end

      # GET /api/v1/nfts
      def nfts
        return unless valid_query_params?(params, %w[account_id serial_number token_id])

        result = account.nfts
        handle_result(result)
      end

      # GET /api/v1/rewards
      def rewards
        return unless valid_query_params?(params, %w[account_id start_time end_time])

        result = account.rewards
        handle_result(result)
      end

      # GET /api/v1/tokens
      def tokens
        return unless valid_query_params?(params, %w[token_id])

        result = account.tokens
        handle_result(result)
      end

      private

      def account
        @account ||= Account.new(account_id: params.require(:id), network: params.requre(:network))
      end

      # Filter the valid params based on allowed params for each endpoint
      def filtered_params(params)
        params.permit(:account_id, :public_key, :balance, :serial_number, :token_id, :start_time, :end_time)
      end
    end
  end
end
