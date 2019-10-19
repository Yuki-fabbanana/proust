class ChangeDataLatlngToPosts < ActiveRecord::Migration[5.2]
  def up
    change_column :posts, :latitude, :float
    change_column :posts, :longitude, :float
  end

  def down
    change_column :posts, :latitude, :string
    change_column :posts, :longitude, :string
  end
end
