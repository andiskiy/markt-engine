FactoryBot.define do
  factory :item_photo do
    association :item, factory: :item
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', 'test.jpg'), 'image/jpg') }
  end
end
