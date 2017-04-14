class AddTokenToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :token, :string
  end
end
