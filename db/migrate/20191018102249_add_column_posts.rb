class AddColumnPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :release_date, :string
    add_column :posts, :artwork, :string
    add_column :posts, :youtube_link, :string
    add_column :posts, :post_image_id, :string
  end
end
