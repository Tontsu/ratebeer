class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def check_if_admin
    unless User.find(session[:user_id]).admin
      redirect_to :back, notice:"must be admin to do that" 
    end
  end
end
