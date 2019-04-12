FactoryBot.define do
  factory :user do
    first_name       { 'Test' }
    last_name        { 'User' }
    sequence(:email) { |n| "user_#{n}@test.com" }
    password         { 'password' }
    country_code     { 'US' }
    city             { 'Greenwood' }
    address          { '4461 Brownton Road' }
    zip_code         { '38930' }
    phone            { '123456789' }

    factory :super_user do
      sequence(:email) { |n| "super_user_#{n}@test.com" }
      role             { 0 }
    end

    factory :admin do
      sequence(:email) { |n| "admin_user_#{n}@test.com" }
      role             { 1 }
    end
  end
end
