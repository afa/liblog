# coding: UTF-8
class UsersController < ApplicationController
#  helper :user
#  before_filter :current_user, :only=>[:index, :show]
#  before_filter :protect, :except=>[:login]
  before_action :check_ability
  before_action :submenu, :except=>[:login]
  before_action :get_users_submenu, :only=>[:edit, :show]

#  def login
#  end

#  def logout
#   session[:logon] = nil
#   redirect_to index_path
#  end

  def index
   @title = "Список персон"
   @users = User.order("name")
  end

  def new
   @title = 'Add person'
   @user = User.new unless params[:commit]
  end

  def create
  end

  def update
  end

  def edit
   @submenu << { :text=>'Delete', :url=>user_path(@user.id, :method=>:delete) }
   @title = "Edit person #{ @user.name }"
  end

  def destroy
  end

  def show
 #  current_user #@?
   redirect_to users_path if @user.nil?
  end
 protected
  def get_users_submenu
   @user = User.find params[:id]
   @submenu << { :text=>'Edit', :url=>edit_user_path(@user.id) }
  end

  def submenu
   @submenu = [
    {:text=>'Index', :url=>users_path, :check=>'current_user.is_admin?'},
    {:text=>'Add', :url=>new_user_path, :check=>'current_user.is_admin?'}
   ]
  end

  def check_ability
    redirect_to root_path, flash: {error: t('user.need_login')} unless can? :manage, User
  end
#  def protect
#   if session[:logon].nil? then
#    session[:return_to] = "http://#{request.host}:#{request.port+request.fullpath}"
#    flash[:error] =  "Must be logged in"
#    redirect_to login_users_path
#    return false
#   end
#   #current_user #@?
#  end 
end
