class BlogController < ApplicationController
  before_filter :protect, :except=>[ :dated, :index, :show ]
  def initialize
   @submenu = [
    {:text=>'Записи', :action=>'index'},
    {:text=>'Добавить', :action=>'post'},
   ]
  end
#(:options => {:theme => 'advanced',
#   :browsers => %w{msie gecko},
#   :theme_advanced_toolbar_location => "top",
#   :theme_advanced_toolbar_align => "left",
#   :theme_advanced_resizing => true,
#   :theme_advanced_resize_horizontal => false,
#   :paste_auto_cleanup_on_paste => true,
#   :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
#   :theme_advanced_buttons2 => [],
#   :theme_advanced_buttons3 => [],
#   :plugins => %w{contextmenu paste}}
##   :only => [:new, :edit, :show, :index]
#  )

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
   @submenu << { :text=>'Удалить', :action=>'delete', :id=>params[:id] }
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
   @submenu << { :text=>'Редактировать', :action=>'edit', :id=>params[:id] }
   @submenu << { :text=>'Удалить', :action=>'delete', :id=>params[:id] }
   @post = BlogPost.find params[:id]
  end

  def dated
   
   @posts = BlogPost.paginate :all, :page => params[:page]
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
