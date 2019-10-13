class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :songs_title
      t.string :album
      t.string :artist
      t.string :address
      t.string :latitude
      t.string :longitude
      t.text :body

      t.timestamps
    end
  end
end
