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

  def create_oauth
    user = User.find_by username: env["omniauth.auth"].info.nickname
    unless user
      pass = ('A'..'Z').to_a.shuffle[0,12].join  << ('0'..'9').to_a.shuffle[0,12].join << ('a'..'z').to_a.shuffle[0,12].join
      user = User.create(username: env["omniauth.auth"].info.nickname, password: pass.split("").shuffle.join)
    end
    session[:user_id] = user.id
    redirect_to user_path(user), notice: "Welcome back!"
  end

  def destroy
    session[:user_id] = nil

    redirect_to :root
  end

end
