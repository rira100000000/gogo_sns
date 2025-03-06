class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true
  validate :validate_gogo_format
  validate :validate_kana_only
  
  has_many :comments, dependent: :destroy
  has_many :stamps, dependent: :destroy
  
  private
  
  # 575形式（5文字・7文字・5文字）であることをバリデーション
  def validate_gogo_format
    lines = content.strip.split("\n")
    
    # 3行であることを確認
    unless lines.size == 3
      errors.add(:content, "は3行である必要があります")
      return
    end
    
    # 各行の文字数が5-7-5であることを確認
    expected_lengths = [5, 7, 5]
    lines.each_with_index do |line, index|
      # 空白を除去して文字数をカウント
      actual_length = line.gsub(/\s+/, "").length
      unless actual_length == expected_lengths[index]
        errors.add(:content, "の#{index + 1}行目は#{expected_lengths[index]}文字である必要があります（現在: #{actual_length}文字）")
      end
    end
  end
  
  # ひらがな・カタカナのみであることをバリデーション
  def validate_kana_only
    # ひらがな・カタカナ・空白・改行以外の文字が含まれていないか確認
    unless content.match?(/\A[ぁ-んァ-ン\s\n]+\z/)
      errors.add(:content, "はひらがなとカタカナのみ使用できます")
    end
  end
end
