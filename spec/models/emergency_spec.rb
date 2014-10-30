require 'rails_helper'

RSpec.describe Emergency, :type => :model do

  describe "Validations" do

    it "validates presence of date" do
      emergency = FactoryGirl.build(:emergency, date: nil)

      expect(emergency.valid?).to be false
      expect(emergency.errors[:date].present?).to be true
    end
    
  end

end
