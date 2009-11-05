class UserController < ApplicationController
#  helper :user
  before_filter :submenu
  before_filter :protect, :except=>[ :login, :logit, :index, :show ]
  def submenu
   @submenu = [
    {:text=>'Index', :action=>'index', :check=>'take_login.is_admin?'},
    {:text=>'Add', :action=>'add', :check=>'take_login.is_admin?'}
   ]
  end

  protected :submenu

  def logit
   user = User.find_by_username_and_password( params[:username], params[:password]) || GuestUser.new 
   session[:logon] = user.id if user.logged?
   @take_login
   unless user.can_login? 
    redirect_to login_user_path 
   else
    redirect_to session[:return_to] ? session[:return_to] : index_path
    session[:return_to] = nil
   end
  end

  def login
  end

  def logout
   session[:logon] = nil
   redirect_to index_path
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
    redirect_to login_user_path
    return false
   end
   @take_login
  end 
end
