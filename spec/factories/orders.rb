FactoryBot.define do
  factory :order do
    association :user, factory: :user
    association :item, factory: :item
    association :purchase, factory: :purchase
    quantity    { 1 }
  end
end
