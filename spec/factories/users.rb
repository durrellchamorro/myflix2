FactoryGirl.define do
  factory :user do
    full_name Faker::Name.name
    sequence(:email) { Faker::Internet.email }
    # email Faker::Internet.email
    password Faker::Lorem.word
  end
end
