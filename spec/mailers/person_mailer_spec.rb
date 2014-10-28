require "rails_helper"

RSpec.describe PersonMailer, :type => :mailer do
  describe "#welcome" do
    person = Person.find_by_email("alfredo.roca.mas@gmail.com")
    if person.nil?
      person = FactoryGirl.create(:person, name: "Florencio", email: "alfredo.roca.mas@gmail.com")
    end
    # let(:person) { create(:person, name: "Florencio", email: "alfredo.roca.mas@gmail.com") }
    it "sends welcome email" do
      mail = PersonMailer.welcome_email(person).deliver
      expect(PersonMailer.deliveries).not_to be_empty
      expect(mail.from.first).to eq("manager@control.com")
      expect(mail.to).to match_array([person.email])
    end
  end

end
