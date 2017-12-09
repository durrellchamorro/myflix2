FactoryBot.define do
  title = Faker::Name.name
  factory :video do
    title title
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
    slug title
    token "bZr28SlINxY"
    trait :reindex do
      after(:create) do |video, _evaluator|
        video.reindex(refresh: true)
      end
    end
  end
end
