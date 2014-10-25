FactoryGirl.define do
  factory :place do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(3) }
    coord_x { "42.44554545"}
    coord_y { "2.3245345" }
  end
end
