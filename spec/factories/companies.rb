FactoryGirl.define do
  factory :company do
    name { Faker::Name.name }
    activity "factory"
    phone1 { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
  end

end
