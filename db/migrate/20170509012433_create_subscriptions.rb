class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :amount
      t.string :reference_id
      t.integer :current_period_start
      t.integer :current_period_end

      t.timestamps
    end
  end
end
