class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.banned
        redirect_to :back, notice: "YOU HAVE BEEN BANNEDED, PLEASE CONTACT NORTH KOREA!!"
      else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to :root
  end

end
