class SessionController < ApplicationController

  def new

  end

  def create
   user = User.find_by_username_and_password( params[:username], params[:password]) || GuestUser.new
   session[:logon] = user.id if user.logged?
   current_user #@?
   redirect_to index_path
  end

  def destroy
   session[:logon] = nil
   redirect_to index_path
  end

end
