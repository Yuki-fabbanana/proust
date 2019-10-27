require 'rails_helper'

RSpec.describe Post, type: :model do
   # 重複したメールアドレスなら無効な状態であること

   # 曲のタイトルが空だと無効な状態であること

   # アートワークが空だと無効な状態であること

   # 緯度が空だと無効な状態であること

   # 経度が空だと無効な状態であること

   # 本文が空だと無効な状態であること

   # 本文が140字以上だと無効な状態であること
end

  # validates :songs_title, presence: true
  # validates :artwork, presence: true

  # validates :latitude, presence: true
  # validates :longitude, presence: true
  # validates :body, presence: true, length: { maximum: 140 }