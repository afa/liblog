class UserController < ApplicationController
  before_filter :protect, :except=>[ :login, :index, :show ]
  def initialize
   @submenu = [
    {:text=>'Index', :action=>'index'},
    {:text=>'Add', :action=>'add'}
   ]
  end
  def login
   unless params[:username].blank? then
    user = User.find_by_username_and_password params[:username], params[:password] 
    session[:logon] = user.id unless user.nil?
    unless session[:return_to].nil? then
     session[:return_to] = nil
     redirect_to session[:return_to]
    else 
     redirect_to :controller=>'Site', :action=>'index'
    end
   end
  end
  def logout
   delete session[:logon]
  end
  def index
   @title = "Список персон"
   @users = Identity.find :all, :order=>'name'
  end

  def add
   @title = 'Add person'
   @identity = Identity.new unless params[:commit]
  end

  def edit
   @title = 'Edit person'
   @identity = Identity.find params[:id]
  end

  def delete
  end

  def show
  end
 private
  def protect
   if session[:logon].nil? then
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to :controller=>'User', :action=>'login'
    return false
   end
  end 
end
