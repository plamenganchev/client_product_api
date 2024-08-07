Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      post 'client_login', to: 'client_sessions#create'

      resources :brands
      resources :products, only: [:index] do
        collection do
          post :assign_to_client
          get :search
          get :generate_report
          get :accessible
          get :assign_to_user
        end
      end
      resources :cards, only: [] do
        collection do
          post :issue
          put :cancel
          get :generate_report
        end
      end
      resources :users, only: [:create]
      resources :transactions, only: [:create]

      resources :reports, only: [] do
        collection do
          get :by_brand
          get :by_client
          get :transactions, to: 'reports#transactions_report'
        end
      end
      end
    end
end
