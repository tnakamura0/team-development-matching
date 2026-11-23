Rails.application.routes.draw do
  resource :session
  # TODO: #103 パスワード再設定はMVP対象外のため無効化。実装時に有効化する
  # resources :passwords, param: :token
  resource :sign_up, only: [ :show, :create ]
  resources :users, only: [ :show ]
  resources :recruitments, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
    resources :applications, only: [ :create ] do
      member do
        patch :approve
        patch :reject
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "recruitments#index"
end
