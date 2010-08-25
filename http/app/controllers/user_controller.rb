class UserController < ApplicationController
#  helper :user
  before_filter :current_user, :only=>[:index, :show]
  before_filter :protect, :except=>[:login]
  before_filter :submenu, :except=>[:login]
  before_filter :get_identity_submenu, :only=>[:edit, :show]

  def login
  end

  def logout
   session[:logon] = nil
   redirect_to index_path
  end

  def index
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
   @submenu << { :text=>'Delete', :url=>user_path(@identity.id, :method=>:delete) }
   @title = "Edit person #{ @identity.name }"
  end

  def destroy
  end

  def show
 #  current_user #@?
   redirect_to user_index_path if @identity.nil?
  end
 protected
  def get_identity_submenu
   @identity = Identity.find params[:id]
   @submenu << { :text=>'Edit', :url=>edit_user_path(@identity.id) }
  end

  def submenu
   @submenu = [
    {:text=>'Index', :url=>user_index, :check=>'current_user.is_admin?'},
    {:text=>'Add', :url=>new_user, :check=>'current_user.is_admin?'}
   ]
  end

  def protect
   if session[:logon].nil? then
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to login_user_path
    return false
   end
   #current_user #@?
  end 
end
