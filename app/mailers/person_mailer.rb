class PersonMailer < ActionMailer::Base
  default from: "manager@control.com"
  ADMINISTRATOR_MAIL = "alfredo.roca.mas@gmail.com"

  def welcome_email(user)
    @user = user
    @fullname = "#{@user.name} #{@user.lastname}"
    @url = "http://localhost:3000"
    mail  to: "#{@fullname} <#{@user.email}> ", 
          cc: ADMINISTRATOR_MAIL,
          subject: 'Welcome to the Emergency Manager platform!'
  end
end
