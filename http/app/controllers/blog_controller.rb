class BlogController < ApplicationController
  before_filter :protect, :except=>[ :rss, :dated, :index, :show, :named ]
  before_filter :protect_post, :only=>[ :new, :create ]
  before_filter :protect_edit, :only=>[ :edit, :update ]
  before_filter :protect_delete, :only=>[ :delete ]
  def initialize
   @submenu = [
    {:text=>'Записи', :action=>'index'},
    {:text=>'Добавить', :action=>'new', :check=>'take_login.logged? and take_login.has_privilege?("blog.post")'},
   ]
  end
  def rss
    @posts = BlogPost.find(:all, :limit => 50, :order => "created_at DESC")
    render :layout=>false
  end


  def index
   @posts = BlogPost.paginate :all, :order=>'created_at DESC', :page=>params[:page]
   @title = "AfaLog"
  end

  def new 
   @post = BlogPost.new :identity_id=>User.find( session[:logon] ).identity.id
  end

  def create
   post = BlogPost.new params[:post]
   if post.save then
    redirect_to :action=>'index'
    flash[:notice] = 'Post stored'
   else
    flash[:error] = 'Ошибка сохранения'
    redirect_to :action=>:new
   end
  end

  def edit
#   @submenu << { :text=>'Удалить', :action=>'destroy', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' }
   @post = BlogPost.find params[:id]
  end

  def update
   @post = BlogPost.find params[:id]
   if @post.update_attributes(params[:post])
#   @post.title=params[:post][:title]
#   @post.text=params[:post][:text]
#   @post.name=params[:post][:name]
#   if @post.save then
    redirect_to :action=>'index'
    flash[:notice] = 'Post stored'
   else
    flash[:error] = 'Ошибка сохранения'
    redirect_to :action=>:edit
   end
  end

  def destroy
   post = BlogPost.find params[:id]
   post.destroy
   redirect_to :action=>'index'
  end

  def show
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.edit")' }
#   @submenu << { :text=>'Удалить', :action=>'destroy', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' }
   @post = BlogPost.find params[:id]
   @title = (@post.title.nil? or @post.title.blank?) ? 'AfaLog' : @post.title + ' / AfaLog'
  end

  def dated
   
   @posts = BlogPost.paginate :all, :page => params[:page]
  end
  def named
   @post = BlogPost.find_by_name params[:id]
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>@post.id, :check=>'take_login.logged? and take_login.has_privilege?("blog.edit")' } unless @post.nil?
#   @submenu << { :text=>'Удалить', :action=>'delete', :id=>@post.id, :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' } unless @post.nil?
   redirect_to :action=>'index' if @post.nil?
   @title = (@post.title || '...') + ' / AfaLog'
  end
 protected
  def protect
   unless take_login.logged?
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to login_user_path
    return false
   end
  end
  def protect_post
   unless take_login.has_privilege? 'blog.post'
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

  def protect_edit
   unless take_login.has_privilege? 'blog.edit'
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end

  def protect_delete
   unless take_login.has_privilege? 'blog.delete'
    flash[:error] = "Недостаточно привилегий для выполнения операции"
    redirect_to :action=>'index'
    return false
   end
  end
end
