class ToDoController < ApplicationController
  before_filter :prot_unlogged, :only=>[:edit, :delete, :add]
  before_filter :prot_admin, :only=>[:edit, :delete, :add]
  def initialize
   @submenu = [
    {:text=>'Index', :action=>'index'},
    {:text=>'Add', :action=>'add'}
   ]
  end
  def index
   @title = 'Хотелки'
   @todos = ToDo.paginate :all, :conditions=>'parent is null', :page=>params[:page]
  end

  def show
   @todo = ToDo.find params[:id]
   @submenu << { :text=>'Edit', :action=>'edit', :id=>@todo.id }
   @submenu << { :text=>'AddChild', :action=>'add', :id=>@todo.id }
   if @todo.nil? then
    flash[:error] = "Хотелка с id=#{params[:id]} не найдена."
    redirect_to todo_path(:action=>'index')
   else
    @title = "Хотелка № #{ @todo.id }" unless @todo.nil?
   end
  end

  def add
   if params[:commit] then
    parent_id = params[:todo].delete(:parent)
    parent = ToDo.find( parent_id ) if parent_id
    todo = ToDo.new(params[:todo])
    parent.childs << todo unless parent.nil?
    if todo.save then 
     flash[:notice] = "Хотелка успешно сохранена"
    else 
     flash[:error] = "Не удалось добавить хотелку"
    end
    redirect_to todo_path :action => 'index'
   else
    if params[:id]
     @parent = ToDo.find(params[:id])
     @todo = ToDo.new(:parent=>@parent, :to_date=>@parent.to_date)
    else
     @todo = ToDo.new( :to_date=> Date.current.next_month.beginning_of_month , :done=>false )
    end
   end
  end

  def edit
   @todo = ToDo.find params[:id]
   @submenu << { :text=>'Delete', :action=>'delete', :id=>@todo.id, :type=>'button' }
   if params[:commit]
    @todo.to_date = params[:todo][:to_date]
    @todo.text = params[:todo][:text]
    @todo.done = params[:todo][:done]
    if @todo.save then
     flash[:notice] = 'Хотелка сохранена'
     redirect_to todo_path(:action=>'index')
    else
     flash[:error] = 'Ошибка сохранения хотелки'
    end
   else
   end
  end

  def delete
   todo = ToDo.find(params[:id]) if params[:id]
   if todo and todo.destroy then
    flash[:notice] = "Хотелка успешно удалена"
   else
    flash[:error] = "Ошибка удаления хотелки"
   end
   redirect_to todo_path( {:action=>'index'} )
  end

  def prot_unlogged
   @user ||= take_login
   redirect_to todo_path(:action=>'index') if @user.kind_of?(GuestUser)
   return false if @user.kind_of?(GuestUser)
  end
  
  def prot_admin
   @user ||= take_login
#   unless @user.has_priv?('root') then
#    redirect_to todo_path(:action=>'index')
#    return false
#   end
  end
end
