class LoginsController < ApplicationController

  def show
  end

  def create
    username = params[:username]
    password = params[:password]
    if username.nil? or password.nil?
      flash[:warning] = "username or password not provided."
      return redirect_to login_path
    end
    if user = User.new.authenticate_ldap(username, password)
      session[:current_user_id] = user[:uid]
      session[:current_user_email] = user[:email]
      flash[:success] = "You have successfully logged in."
    else
      flash[:danger] = "Log in failed."
    end
    redirect_to root_url
  end

  def destroy
    session[:current_user_id] = nil
    session[:current_user_email] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to login_path
  end

end
