FactoryGirl.define do
  factory :payment do
    association :user, factory: :user
    amount 999
    reference_id "reference_id_string"
  end
end
