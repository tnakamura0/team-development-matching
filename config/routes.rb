Rails.application.routes.draw do
  # home関連は共通レイアウト実装時に削除する
  # 現状は開発中のログアウト実行用として /home に残す
  get "home", to: "home#index"

  resource :session
  # パスワード再設定はスコープ外のため無効化。要件が決まったら有効化。
  # resources :passwords, param: :token
  resource :sign_up, only: [ :show, :create ]
  resources :recruitments, only: [ :index ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "recruitments#index"
end
