# coding: UTF-8
class SessionController < ApplicationController

  def new

  end

  def create
   user = User.find_by_username_and_password( params[:username], params[:password]) || GuestUser.new
   session[:logon] = user.id if user.logged?
   @logged = user
   User.current = user
   #current_user #@?
   Rails.logger.info "tttest"
   Rails.logger.info User.current.inspect
   redirect_to root_path
  end

  def destroy
   session[:logon] = nil
   redirect_to root_path
  end

end
