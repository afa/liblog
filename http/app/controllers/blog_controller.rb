class BlogController < ApplicationController
  before_filter :protect, :except=>[ :dated, :index, :show ]
  before_filter :protect_post, :only=>[ :post ]
  before_filter :protect_edit, :only=>[ :edit ]
  before_filter :protect_delete, :only=>[ :delete ]
  def initialize
   @submenu = [
    {:text=>'Записи', :action=>'index'},
    {:text=>'Добавить', :action=>'post', :check=>'take_login.logged? and take_login.has_privilege?("blog.post")'},
   ]
  end

  def index
   @posts = BlogPost.paginate :all, :order=>'created_at DESC', :page=>params[:page]
  end

  def post
   if params[:commit] then
    post = BlogPost.new params[:post]
    if post.save then
     redirect_to :action=>'index'
     flash[:notice] = 'Post stored'
    else
     flash[:error] = 'Ошибка сохранения'
    end
   else
    @post = BlogPost.new :identity_id=>User.find( session[:logon] ).identity.id
   end
  end

  def edit
   @submenu << { :text=>'Удалить', :action=>'delete', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' }
   @post = BlogPost.find params[:id]
   if params[:commit] then
    @post.title=params[:post][:title]
    @post.text=params[:post][:text]
    @post.name=params[:post][:name]
    if @post.save then
     redirect_to :action=>'index'
     flash[:notice] = 'Post stored'
    else
     flash[:error] = 'Ошибка сохранения'
    end
   end
  end

  def delete
   post = BlogPost.find params[:id]
   post.destroy
   redirect_to :action=>'index'
  end

  def show
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.edit")' }
   @submenu << { :text=>'Удалить', :action=>'delete', :id=>params[:id], :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' }
   @post = BlogPost.find params[:id]
  end

  def dated
   
   @posts = BlogPost.paginate :all, :page => params[:page]
  end
  def named
   @post = BlogPost.find_by_name params[:name]
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>@post.id, :check=>'take_login.logged? and take_login.has_privilege?("blog.edit")' } unless @post.nil?
   @submenu << { :text=>'Удалить', :action=>'delete', :id=>@post.id, :check=>'take_login.logged? and take_login.has_privilege?("blog.delete")' } unless @post.nil?
   redirect_to :action=>'index' if @post.nil?
  end
 private
  def protect
   unless take_login.logged?
    session[:return_to] = request.request_uri
    flash[:error] =  "Must be logged in"
    redirect_to :controller=>'User', :action=>'login'
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
