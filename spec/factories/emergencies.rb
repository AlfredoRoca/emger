FactoryGirl.define do
  factory :emergency do
    date Faker::Time.between(30.days.ago, Time.now, :all)
    status "open"
    simulacrum false
  end

end
