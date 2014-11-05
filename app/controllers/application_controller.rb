class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    current_user_id = session[:current_user_id]
    person = Person.find(current_user_id)
    if current_user_id
      @current_user ||= person
    end
    rescue ActiveRecord::RecordNotFound
      current_user_id = nil
      @current_user = nil
  end

end
