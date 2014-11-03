FactoryGirl.define do
  factory :followup do
    title         Faker::Lorem.sentence
    description   Faker::Lorem.paragraph
    emergency_id  1
  end

end
