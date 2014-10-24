require 'rails_helper'

RSpec.describe Company, :type => :model do
  describe "validations" do
    it "validates presence of name" do
      company = FactoryGirl.build(:company, name: nil)
      expect(company.valid?).to be false
      expect(company.errors[:name].present?).to be true
    end
    it "validates uniqueness of name" do
      company1 = FactoryGirl.create(:company, name: "company")
      company2 = FactoryGirl.build(:company, name: "company")
      expect(company2.valid?).to be false
      expect(company2.errors[:name].present?).to be true
    end
  end
end
