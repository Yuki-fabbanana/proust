class Post < ApplicationRecord
  belongs_to :user
  attachment :post_image


  validates :songs_title, presence: true
  validates :artist, presence: true
  validates :artwork, presence: true

  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :body, presence: true, length: { maximum: 140 }
end
