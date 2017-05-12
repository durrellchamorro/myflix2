class Payment < ActiveRecord::Base
  belongs_to :user
  monetize :amount, as: "usd"
end
