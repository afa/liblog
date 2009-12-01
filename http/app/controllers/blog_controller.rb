class BlogController < ApplicationController
  before_filter :submenu
  
  before_filter :get_post, :only => [:edit, :update, :destroy, :show]
  before_filter :protect, :except=>[ :rss, :dated, :index, :show, :named ]
  before_filter :protect_post, :only=>[ :new, :create ]
  before_filter :protect_edit, :only=>[ :edit, :update ]
  before_filter :protect_delete, :only=>[ :delete ]

  def rss
    @posts = BlogPost.only_50.lasts.find :all
    render :layout=>false
  end

  def index
   @posts = BlogPost.lasts.paginate :all, :page=>params[:page]
   @title = "AfaLog"
  end

  def new 
   @post = take_login.identity.posts.build 
  end

  def create
   post = BlogPost.new params[:post]
   if post.save then
    redirect_to :action=>'index'
    flash[:notice] = 'Post stored'
   else
    flash[:error] = 'Ошибка сохранения'
    render :action=>:new
   end
  end

  def edit
  end

  def update
   if @post.update_attributes(params[:post])
    redirect_to :action=>'index'
    flash[:notice] = 'Post stored'
   else
    flash[:error] = 'Ошибка сохранения'
    redirect_to :action=>:edit
   end
  end

  def destroy
   @post.destroy
   redirect_to :action=>'index'
  end

  def show
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>params[:id], :check=>'take_login.logged? and take_login.is_admin?' }
   @title = (@post.title.nil? or @post.title.blank?) ? 'AfaLog' : @post.title + ' / AfaLog'
  end

  def dated
   @posts = BlogPost.paginate :all, :page => params[:page]
  end

  def named
   @post = BlogPost.find_by_name params[:id]
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>@post.id, :check=>'take_login.logged? and take_login.is_admin?' } 
   redirect_to :action=>'index' if @post.nil?
   @title = (@post.title || '...') + ' / AfaLog'
  end

 protected

  def submenu
   @submenu = [
    {:text=>'Записи', :url=>blog_index_path},
    {:text=>'Добавить', :url=>new_blog_path, :check=>'take_login.logged? and take_login.is_admin?'},
   ]
  end

  def get_post
   @post = BlogPost.find params[:id]
  end

  def protect
   unless take_login.logged?
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to login_user_path
    return false
   end
  end
  def protect_post
   unless take_login.is_blogger?
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

  def protect_edit
   unless take_login.is_admin?
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

  def protect_delete
   unless take_login.is_admin?
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end
end
