class LoginController < ApplicationController
  def new
  end

  def create
    user = Person.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      flash[:success] = "Login sucessful! Welcome #{user.name}!"
      session[:current_user_id] = user.id
      redirect_to emergencies_path
    else
      flash[:error] = "Login was not sucessful"
      render :new
    end
  end

  def destroy
    session[:current_user_id] = nil
    respond_to do |format|
      format.html { redirect_to emergencies_path }
      format.js   { render js: "window.location.href='#{emergencies_path}'" }
    end
  end
end
