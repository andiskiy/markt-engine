FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category ##{n}" }
    description     { 'This is test Category' }
  end
end
