class PersonMailer < ActionMailer::Base
  default from: "manager@control.com"
  ADMINISTRATOR_MAIL = "alfredo.roca.mas@gmail.com"

  def welcome_email(person)
    @person = person
    @fullname = "#{@person.name} #{@person.lastname}"
    @url = "http://localhost:3000"
    mail  to: "#{@fullname} <#{@person.email}> ", 
          cc: ADMINISTRATOR_MAIL,
          subject: 'Welcome to the Emergency Manager platform!'
  end
end
