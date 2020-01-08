class Tweet < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments  # commentsテーブルとのアソシエーション

  def self.search(search)
    return Tweet.all unless search
    # Tweet.where('text LIKE(?)', "%#{search}%")
    search = "%#{search}%"
    Tweet.find_by_sql(["select * from tweets where text like ? ", search])
  end
end
