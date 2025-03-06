class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :username, presence: true, uniqueness: true
  
  # 投稿関連のアソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :stamps, dependent: :destroy
  
  # フォロー関連のアソシエーション
  has_many :active_follows, class_name: "Follow",
                            foreign_key: "follower_id",
                            dependent: :destroy
  has_many :passive_follows, class_name: "Follow",
                             foreign_key: "followed_id",
                             dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end
  
  # ユーザーのフォローを解除する
  def unfollow(other_user)
    following.delete(other_user)
  end
  
  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # フォローしているユーザーの投稿を取得
  def feed
    following_ids = "SELECT followed_id FROM follows WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
end
