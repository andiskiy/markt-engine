FactoryBot.define do
  factory :user do
    first_name   { 'Test' }
    last_name    { 'User' }
    email        { 'main_user@test.com' }
    password     { 'password' }
    country_code { 'US' }
    city         { 'Greenwood' }
    address      { '4461 Brownton Road' }
    zip_code     { '38930' }
    phone        { '123456789' }
  end
end
