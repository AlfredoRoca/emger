FactoryGirl.define do
  factory :followup do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end

end
