FactoryGirl.define do
  factory :place do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(3) }
    coord_x { Random.new.rand(41098208..41112436)/1000000 }
    coord_y { Random.new.rand(156760..1198602)/1000000 }
  end
end
