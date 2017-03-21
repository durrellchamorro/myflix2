FactoryGirl.define do
  factory :comedy_video, class: Video do
    title Faker::Name.name
    small_cover_url '/tmp/family_guy.jpg'
    large_cover_url "http://dummyimage.com/665x375/000000/00a2ff"
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
  end
end

FactoryGirl.define do
  factory :video do
    title Faker::Name.name
    small_cover_url '/tmp/family_guy.jpg'
    large_cover_url "http://dummyimage.com/665x375/000000/00a2ff"
    description Faker::Lorem.paragraphs(1).first
    association :category, factory: :category, name: "TV Comedies"
  end
end
