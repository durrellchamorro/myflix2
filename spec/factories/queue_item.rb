FactoryBot.define do
  factory :queue_item do
    position (1..10).to_a.sample
    user
    video
  end
end
