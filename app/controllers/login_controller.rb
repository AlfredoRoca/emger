class LoginController < ApplicationController

  def create
    user = Person.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      flash[:success] = "Login sucessful! Welcome #{user.name}!"
      session[:current_user_id] = user.id
      redirect_to root_url
    else
      flash[:error] = "Login was not sucessful"
      render :new
    end
  end

  def destroy
    session[:current_user_id] = nil
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js   { render js: "window.location.href='#{root_path}'" }
    end
  end
end
