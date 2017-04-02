FactoryGirl.define do
  factory :invitation do
    association :inviter, factory: :user
    recipient_name Faker::Name.name
    sequence(:recipient_email) { Faker::Internet.email }
    message Faker::Lorem.paragraphs(1).first
    sequence(:token) { SecureRandom.urlsafe_base64 }
  end
end
