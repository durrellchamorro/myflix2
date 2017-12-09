class Subscription < ApplicationRecord
  belongs_to :user
  monetize :amount, as: "usd"
end
