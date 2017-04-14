FactoryGirl.define do
  factory :photo do
    association :video, factory: :video
    image '{"id":"05b4bc742a2e0ff08d6eb12717f5f6e4.JPG","storage":"store","metadata":{"size":573854,"filename":"IMG_7100.JPG","mime_type":"image/jpeg"}}'
  end
end
