require 'rails_helper'

RSpec.describe Place, :type => :model do
  describe "validations" do
    it "validates presence of name" do
      place = FactoryGirl.build(:place, name: nil)
      expect(place.valid?).to be false
      expect(place.errors[:name].present?).to be true
    end
    it "validates uniqueness of name" do
      place1 = FactoryGirl.create(:place, name: "here")
      place2 = FactoryGirl.build(:place, name: "here")
      expect(place2.valid?).to be false
      expect(place2.errors[:name].present?).to be true
    end
  end
end
