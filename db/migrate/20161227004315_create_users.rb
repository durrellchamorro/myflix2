class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension("citext")
    
    create_table :users do |t|
      t.string 'full_name'
      t.citext 'email'
      t.string 'password_digest'
      t.timestamps
    end
  end
end
