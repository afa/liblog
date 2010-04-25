class UserController < ApplicationController
#  helper :user
  before_filter :submenu
  before_filter :protect, :except=>[ :login, :index, :show ]
  before_filter :current_user, :only=>[:index, :show]
  before_filter :get_identity_submenu, :only=>[:edit, :show]
 #:logit, 

#  def logit
#   user = User.find_by_username_and_password( params[:username], params[:password]) || GuestUser.new 
#   session[:logon] = user.id if user.logged?
#   @take_login
#   unless user.can_login? 
#    redirect_to login_user_path 
#   else
#    redirect_to session[:return_to] ? session[:return_to] : index_path
#    session[:return_to] = nil
#   end
#  end

  def login
  end

  def logout
   session[:logon] = nil
   redirect_to index_path
  end
  def index
#   current_user #@?
   @title = "Список персон"
   @users = Identity.order_by_name.all
  end

  def new
   @title = 'Add person'
   @identity = Identity.new unless params[:commit]
  end

  def create
  end

  def update
  end

  def edit
   @submenu << { :text=>'Delete', :action=>'delete', :id=>@identity.id }
   @title = "Edit person #{ @identity.name }"
  end

  def destroy
  end

  def show
 #  current_user #@?
   redirect_to :action=>'index' if @identity.nil?
  end
 protected
  def get_identity_submenu
   @identity = Identity.find params[:id]
   @submenu << { :text=>'Edit', :action=>'edit', :id=>@identity.id }
  end

  def submenu
   @submenu = [
    {:text=>'Index', :action=>'index', :check=>'current_user.is_admin?'},
    {:text=>'Add', :url=>new_user_path, :check=>'current_user.is_admin?'}
   ]
  end

  def protect
   if session[:logon].nil? then
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to login_user_path
    return false
   end
   current_user #@?
  end 
end
