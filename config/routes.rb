Rails.application.routes.draw do
  # ルートパス
  root 'home#index'
  
  # Devise（ユーザー認証）
  devise_for :users
  
  # ユーザー関連
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :following, :followers
    end
  end
  
  # フォロー関連
  resources :follows, only: [:create, :destroy]
  
  # 投稿関連
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :stamps, only: [:create, :destroy]
  end
  
  # タイムライン
  get 'timeline', to: 'home#timeline'
  
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
