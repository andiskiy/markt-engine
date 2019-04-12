FactoryBot.define do
  factory :purchase do
    association  :user, factory: :user
    country_code { 'US' }
    city         { 'Union City' }
    address      { '4883 Pooz Street' }
    zip_code     { '38261' }
    phone        { '123456789' }

    factory :pending_purchase do
      status { Purchase.statuses['pending'] }
    end

    factory :processing_purchase do
      status { Purchase.statuses['processing'] }
    end

    factory :completed_purchase do
      status     { Purchase.statuses['completed'] }
      ordered_at { 1.second.ago }
    end
  end
end
