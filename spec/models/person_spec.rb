require 'rails_helper'

RSpec.describe Person, :type => :model do
  describe "validations" do
    it "validates presence of email" do
      person = FactoryGirl.build(:person, email: nil)
      expect(person.valid?).to be false
      expect(person.errors[:email].present?).to be true
    end
    it "validates uniqueness of email" do
      person1 = FactoryGirl.create(:person, email: "pepito@p.com")
      person2 = FactoryGirl.build(:person, email: "pepito@p.com")
      expect(person2.valid?).to be false
      expect(person2.errors[:email].present?).to be true
    end
    it "validates presence of name" do
      person = FactoryGirl.build(:person, name: nil)
      expect(person.valid?).to be false
      expect(person.errors[:name].present?).to be true
    end
    it "validates presence of lastname" do
      person = FactoryGirl.build(:person, lastname: nil)
      expect(person.valid?).to be false
      expect(person.errors[:lastname].present?).to be true
    end
  end
end
