class Stamp < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # ユーザーは1つの投稿に1回だけスタンプできる
  validates :user_id, uniqueness: { scope: :post_id }
end
