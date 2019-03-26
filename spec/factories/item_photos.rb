FactoryBot.define do
  factory :item_photo do
    association :item, factory: :item
    photo       { '' }
  end
end
