class BlogsController < ApplicationController
  before_filter :submenu
  
  before_filter :parse_named_id, :only=>[:show]
  before_filter :get_post, :only => [:edit, :update, :destroy, :show]
  before_filter :protect, :except=>[ :rss, :dated, :index, :show, :named ]
  before_filter :protect_post, :only=>[ :new, :create ]
  before_filter :protect_admins_access, :only=>[ :edit, :update, :delete ]
  before_filter :protect_delete, :only=>[ :delete ]
  before_filter :get_tags, :only=>[:index]

  def rss
    @posts = BlogPost.only_50.lasts.all
    render :layout=>false
  end

  def index
   @posts = BlogPost.lasts.paginate(:page=>params[:page])
   @title = "AfaLog"
  end

  def new 
   @post = current_user.identity.posts.build 
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
   @submenu << { :text=>'Редактировать', :url=>edit_blog_path(@post), :check=>'current_user.logged? and current_user.is_admin?' }
   @title = (@post.title.nil? or @post.title.blank?) ? 'AfaLog' : @post.title + ' / AfaLog'
  end

  def dated
   @posts = BlogPost.paginate :all, :page => params[:page]
  end

  def named
   @post = BlogPost.find_by_name params[:id]
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>@post.id, :check=>'current_user.logged? and current_user.is_admin?' } 
   redirect_to :action=>'index' if @post.nil?
   @title = (@post.title || '...') + ' / AfaLog'
  end

 protected
  def parse_named_id
   if params[:id].to_s.strip != params[:id].to_s.strip.to_i
    @post = BlogPost.find_by_name params[:id].to_s.strip
   end
  end

  def get_tags
   @tags = [] #TODO добавить тэги (лучше гемом)
  end

  def submenu
   @submenu = [
    {:text=>'Записи', :url=>blogs_path},
    {:text=>'Добавить', :url=>new_blog_path, :check=>'current_user.logged? and current_user.is_admin?'},
   ]
  end

  def get_post
   @post = BlogPost.find params[:id] unless @post
  end

  def protect
   unless current_user.logged?
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to login_users_path
    return false
   end
  end
  def protect_post
   unless current_user.is_blogger?
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

  def protect_admins_access
   unless current_user.is_admin?
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

end
