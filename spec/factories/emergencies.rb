FactoryGirl.define do
  factory :emergency do
    date        Faker::Time.between(30.days.ago, Time.now, :all)
    status      Emergency::EMERGENCY_STATUS_OPEN
    simulacrum  false
    place_id    0
  end

end
