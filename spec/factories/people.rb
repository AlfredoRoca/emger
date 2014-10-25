FactoryGirl.define do
  factory :person do
    name      { Faker::Name.name }
    lastname  { Faker::Name.name }
    phone     { Faker::PhoneNumber.phone_number }
    email     { Faker::Internet.email }
  end
end
