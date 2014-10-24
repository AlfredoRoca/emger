FactoryGirl.define do
  factory :company do
    name { Faker::Name.name }
    type ""
    phone1 { "999000999" }
    email { Faker::Internet.email }
  end

end
