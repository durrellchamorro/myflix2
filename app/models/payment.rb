class Payment < ApplicationRecord
  belongs_to :user
  monetize :amount, as: "usd"
end
