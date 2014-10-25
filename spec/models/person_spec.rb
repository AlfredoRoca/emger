require 'rails_helper'

RSpec.describe Person, :type => :model do
  describe "validations" do
    it "validates presence of name" do
      person = FactoryGirl.build(:person, name: nil)
      expect(person.valid?).to be false
      expect(person.errors[:name].present?).to be true
    end
    it "validates uniqueness of name" do
      person1 = FactoryGirl.create(:person, name: "pepito")
      person2 = FactoryGirl.build(:person, name: "pepito")
      expect(person2.valid?).to be false
      expect(person2.errors[:name].present?).to be true
    end
  end
end
