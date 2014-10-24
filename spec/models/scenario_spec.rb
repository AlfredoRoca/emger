require 'rails_helper'

RSpec.describe Scenario, :type => :model do
  describe "Validations" do
    context :name do
      it "validates presence of name" do 
        scenario = FactoryGirl.build(:scenario, name: nil)

        expect(scenario.valid?).to be false
        expect(scenario.errors[:name].present?).to be true
      end
      it "validates uniqueness of name" do
        scenario1 = FactoryGirl.create(:scenario, name: "pepe")
        scenario2 = FactoryGirl.build(:scenario, name: "pepe")

        expect(scenario2.valid?).to be false
        expect(scenario2.errors[:name].present?).to be true
      end
    end
    context :description do
      it "validates presence of description" do
        scenario = FactoryGirl.build(:scenario, description: nil)

        expect(scenario.valid?).to be false
        expect(scenario.errors[:description].present?).to be true
      end
      it "validates uniqueness of description" do 
        scenario1 = FactoryGirl.create(:scenario, description: "escenario")
        scenario2 = FactoryGirl.build(:scenario, description: "escenario")

        expect(scenario2.valid?).to be false
        expect(scenario2.errors[:description].present?).to be true
      end
    end
  end
end
