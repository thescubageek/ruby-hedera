# config/routes.rb
namespace :api do
  namespace :v1 do

    scope ':network', constraints: { network: /main|test|preview/ } do

      # Accounts routes
      resources :accounts, only: [:index, :show] do
        member do
          get :nfts
          get :rewards
          get :tokens
        end

        resource :allowances, only: [] do
          collection do
            get :crypto
            get :tokens
            get :nfts
          end
        end
      end

      # Balances routes
      resources :balances, only: [:index]

      # Blocks routes
      resources :blocks, only: [:index, :show]

      # Contracts routes
      resources :contracts, only: [:index, :show] do
        collection do
          post :call
        end

        member do
          get :results
          get :logs
          get :state
        end

        resources :results, only: [:index, :show] do
          member do
            get :actions
            get :opcodes
          end

          collection do
            get :logs
          end
        end

        get ':contractIdOrAddress/results/logs', to: 'results#logs_by_contract'
      end

      # Network routes
      namespace :network do
        get 'nodes', to: 'networks#nodes'
        get 'stake', to: 'networks#stake'
        get 'supply', to: 'networks#supply'
        get 'fees', to: 'networks#fees'
        get 'exchangerate', to: 'networks#exchangerate'
      end

      # Schedules routes
      resources :schedules, only: [:index, :show]

      # Topics routes
      resources :topics, only: [:show] do
        resources :messages, only: [:index, :show], param: :sequence_number
      end
        
      # Tokens routes
      resources :tokens, only: [:index, :show] do
        member do
          get :balances
          get :nfts
        end

        # Tokens NFTs routes
        resources :nfts, only: [:index, :show], param: :serial_number do
          member do
            get :transactions
          end
        end
      end

      # Transactions routes
      resources :transactions, only: [:index, :show]
    end
  end
end
