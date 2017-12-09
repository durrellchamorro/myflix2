FactoryBot.define do
  factory :review do
    content Faker::Lorem.paragraphs(1).first
    rating Faker::Number.between(1, 5)
    user
    video
  end
end
