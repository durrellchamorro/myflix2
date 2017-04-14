FactoryGirl.define do
  title = Faker::Name.name
  factory :video do
    title title
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
    slug title
    token "bZr28SlINxY"
  end
end
