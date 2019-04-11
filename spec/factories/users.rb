FactoryBot.define do
  factory :user do
    first_name   { 'Test' }
    last_name    { 'User' }
    email        { 'user@test.com' }
    password     { 'password' }
    country_code { 'US' }
    city         { 'Greenwood' }
    address      { '4461 Brownton Road' }
    zip_code     { '38930' }
    phone        { '123456789' }

    factory :super_user do
      email { 'super_user@test.com' }
      role  { 0 }
    end

    factory :admin do
      email { 'admin_user@test.com' }
      role  { 1 }
    end
  end
end
