require "rails_helper"
ADMINISTRATOR_MAIL = "alfredo.roca.mas@gmail.com" # personMailer.rb

RSpec.describe PersonMailer, :type => :mailer do

  describe "#welcome" do

    let(:person) { Person.find_by_email("alfredo.roca.mas@gmail.com") }

    if person.nil?
      let(:person) { FactoryGirl.create(:person, name: "Florencio", email: "alfredo.roca.mas@gmail.com") }
    end

    # let(:person) { create(:person, name: "Florencio", email: "alfredo.roca.mas@gmail.com") }
    it "sends welcome email to new user and to the administrator" do
      mail = PersonMailer.welcome_email(person).deliver

      expect(ActionMailer::Base.deliveries).not_to be_empty
      expect(mail.from.first).to eq("manager@control.com")
      expect(mail.to).to match_array([person.email])
      expect(mail.cc).to match_array([ADMINISTRATOR_MAIL])
    end
    
  end

end
