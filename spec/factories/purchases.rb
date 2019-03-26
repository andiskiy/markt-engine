FactoryBot.define do
  factory :purchase do
    association  :user, factory: :user
    country_code { 'US' }
    city         { 'Union City' }
    address      { '4883 Pooz Street' }
    zip_code     { '38261' }
    phone        { '123456789' }
  end
end
