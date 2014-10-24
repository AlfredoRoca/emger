FactoryGirl.define do
  factory :scenario do
    name        { Faker::Name.name }
    description { Faker::Name.name }
  end

end
