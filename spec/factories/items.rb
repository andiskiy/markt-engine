FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item ##{n}" }
    description     { 'This is test Item' }
    price           { 10 }
    association     :category, factory: :category
  end
end
