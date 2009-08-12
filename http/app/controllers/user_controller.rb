class UserController < ApplicationController
#  helper :user
  before_filter :protect, :except=>[ :login, :index, :show ]
  def initialize
   @submenu = [
    {:text=>'Index', :action=>'index', :check=>'take_login.logged?'},
    {:text=>'Add', :action=>'add', :check=>'take_login.can_admin?'}
   ]
  end
  def login
   unless params[:username].blank? then
    user = User.find_by_username_and_password( params[:username], params[:password]) || GuestUser.new 
    unless user.can_login? 
     redirect_to :action=>'login' 
     return
    end
    session[:logon] = user.id if user.logged?
    @take_login
    if session[:return_to].nil? then
     redirect_to :controller=>'Site', :action=>'index'
    else 
     redirect_to session[:return_to]
     session[:return_to] = nil
    end
   end
  end
  def logout
   session[:logon] = nil
   redirect_to :controller=>'Site', :action=>'index'
  end
  def index
   @take_login
   @title = "Список персон"
   @users = Identity.find :all, :order=>'name'
  end

  def add
   @title = 'Add person'
   @identity = Identity.new unless params[:commit]
  end

  def edit
   @identity = Identity.find params[:id]
   @submenu << { :text=>'Edit', :action=>'edit', :id=>@identity.id }
   @submenu << { :text=>'Delete', :action=>'delete', :id=>@identity.id }
   @title = "Edit person #{ @identity.name }"
  end

  def delete
  end

  def show
   @take_login
   @identity = Identity.find params[:id]
   @submenu << { :text=>'Edit', :action=>'edit', :id=>@identity.id }
   redirect_to :action=>'index' if @identity.nil?
  end
 private
  def protect
   if session[:logon].nil? then
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to :controller=>'User', :action=>'login'
    return false
   end
   @take_login
  end 
end
