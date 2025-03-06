class CreateStamps < ActiveRecord::Migration[8.0]
  def change
    create_table :stamps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    
    # ユーザーは1つの投稿に1回だけスタンプできるようにする
    add_index :stamps, [:user_id, :post_id], unique: true
  end
end
