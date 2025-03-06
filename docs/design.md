# 575 SNS 設計書

## 要件定義書

### 概要
「575 SNS」は、575形式（俳句・短歌のフォーマット）のみを投稿できるSNSプラットフォームです。

### 機能要件
1. **ユーザー管理**
   - ユーザー登録・ログイン・ログアウト機能
   - プロフィール編集機能
   - ユーザーフォロー機能

2. **投稿機能**
   - 575形式（ひらがな・カタカナのみ）の投稿作成
   - 投稿の表示（タイムライン、ユーザーページ）
   - 投稿の編集・削除

3. **インタラクション機能**
   - 投稿へのコメント機能
   - 投稿へのスタンプ（いいね）機能
   - フォローしているユーザーの投稿タイムライン

4. **バリデーション**
   - 投稿内容がひらがな・カタカナのみであることを確認
   - 投稿が575形式（5文字・7文字・5文字）であることを確認

### 非機能要件
1. **パフォーマンス**
   - ページロード時間を3秒以内に抑える
   - 同時接続ユーザー数100人までの対応

2. **セキュリティ**
   - ユーザー認証の実装
   - XSS、CSRF対策
   - 適切なアクセス制御

3. **ユーザビリティ**
   - レスポンシブデザイン
   - 直感的なUI/UX

## 設計書

### システム概略設計

#### 技術スタック
- **バックエンド**: Ruby on Rails 7.x
- **フロントエンド**: Hotwire (Turbo, Stimulus)
- **データベース**: PostgreSQL
- **認証**: Devise
- **スタイリング**: TailwindCSS

#### システム構成図
```
クライアント (ブラウザ) <--> Webサーバー (Rails) <--> データベース (PostgreSQL)
```

### 機能設計

#### ユーザー管理機能
- ユーザー登録・ログイン（Devise）
- プロフィール編集
- ユーザーフォロー機能
  - フォロー/フォロー解除
  - フォロワー一覧表示
  - フォロー中ユーザー一覧表示

#### 投稿機能
- 新規投稿作成
  - 5-7-5形式のバリデーション
  - ひらがな・カタカナのみのバリデーション
- 投稿一覧表示
  - 全体タイムライン
  - フォロー中ユーザータイムライン
- 投稿詳細表示
- 投稿編集・削除

#### コメント機能
- 投稿へのコメント追加
- コメント一覧表示
- コメント削除

#### スタンプ機能
- 投稿へのスタンプ追加/削除
- スタンプ数の表示
- スタンプしたユーザー一覧表示

### データベース設計

#### テーブル構成

**users**
- id: integer (PK)
- email: string
- encrypted_password: string
- username: string
- profile: text
- created_at: datetime
- updated_at: datetime

**follows**
- id: integer (PK)
- follower_id: integer (FK -> users.id)
- followed_id: integer (FK -> users.id)
- created_at: datetime
- updated_at: datetime

**posts**
- id: integer (PK)
- user_id: integer (FK -> users.id)
- content: text
- created_at: datetime
- updated_at: datetime

**comments**
- id: integer (PK)
- user_id: integer (FK -> users.id)
- post_id: integer (FK -> posts.id)
- content: text
- created_at: datetime
- updated_at: datetime

**stamps**
- id: integer (PK)
- user_id: integer (FK -> users.id)
- post_id: integer (FK -> posts.id)
- created_at: datetime
- updated_at: datetime

### クラス構成

#### モデル
- User: ユーザー情報を管理
- Follow: フォロー関係を管理
- Post: 投稿を管理
- Comment: コメントを管理
- Stamp: スタンプを管理

#### コントローラー
- UsersController: ユーザー関連の処理
- FollowsController: フォロー関連の処理
- PostsController: 投稿関連の処理
- CommentsController: コメント関連の処理
- StampsController: スタンプ関連の処理
- HomeController: ホーム画面表示

#### ビュー
- layouts/: レイアウトテンプレート
- users/: ユーザー関連ビュー
- posts/: 投稿関連ビュー
- comments/: コメント関連ビュー（部分テンプレート）
- stamps/: スタンプ関連ビュー（部分テンプレート）
- home/: ホーム画面ビュー

### バリデーションロジック

#### 575形式のバリデーション
1. 投稿内容を改行で分割
2. 3行であることを確認
3. 各行の文字数が5-7-5であることを確認

#### ひらがな・カタカナのみのバリデーション
1. 正規表現を使用して、ひらがな・カタカナ以外の文字が含まれていないか確認
2. 空白や改行は許可

### ルーティング設計
```ruby
Rails.application.routes.draw do
  devise_for :users
  
  root 'home#index'
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get :following, :followers
    end
  end
  
  resources :follows, only: [:create, :destroy]
  
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :stamps, only: [:create, :destroy]
  end
  
  get 'timeline', to: 'home#timeline'
end
```

## 実装計画

### フェーズ1: 基本設定とユーザー管理
- Railsプロジェクト作成
- Devise導入とユーザーモデル作成
- ユーザープロフィール機能実装

### フェーズ2: 投稿機能
- 投稿モデル作成
- 575バリデーション実装
- ひらがな・カタカナバリデーション実装
- 投稿CRUD機能実装

### フェーズ3: インタラクション機能
- コメント機能実装
- スタンプ機能実装
- フォロー機能実装

### フェーズ4: UI/UXの改善
- TailwindCSSによるスタイリング
- レスポンシブデザイン対応
- Hotwireによる非同期処理実装

### フェーズ5: テストとデプロイ
- 単体テスト作成
- 統合テスト作成
- デプロイ準備と実行