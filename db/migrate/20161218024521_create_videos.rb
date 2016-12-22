class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :small_cover_url
      t.string :large_cover_url
      t.text :description
    end
  end
end
