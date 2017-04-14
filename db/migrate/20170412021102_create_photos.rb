class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :video_id
      t.text :image_data
    end
  end
end
