Rails.application.routes.draw do
  resource :session
  # パスワード再設定はスコープ外のため無効化。要件が決まったら有効化。
  # resources :passwords, param: :token
  resource :sign_up, only: [ :show, :create ]
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
