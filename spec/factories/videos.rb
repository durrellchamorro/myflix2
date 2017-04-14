FactoryGirl.define do
  factory :comedy_video, class: Video do
    title Faker::Name.name
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
  end
end

FactoryGirl.define do
  title = Faker::Name.name
  factory :video do
    title title
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
    slug title
  end
end
