class ConfigController < ApplicationController
  before_filter :protect
  def initialize
   @submenu = [
    {:text=>'Список', :action=>'index'},
    {:text=>'Добавить', :action=>'add'}
   ]
  end
  def index
   @items = SiteConfig.find :all
  end

  def edit
   @item = SiteConfig.find params[:id]
   @submenu << {:text=>'Удалить', :action=>'delete', :id=>@item.id}
   if params[:commit] then
    @item.value = params[:item][:value]
    if @item.save then
     flash[:notice] = "Параметр конфигурации сайта #{@item.name} сохранен"
    else
     flash[:error] = "Ошибка сохранения параметра конфигурации #{@item.name}"
    end
    redirect_to :action=>'index'
   end
  end

  def add
   if params[:commit] then
    @item = SiteConfig.new params[:item]
    if @item.save then
     flash[:notice] = 'Параметр конфигурации сайта сохранен'
    else
     flash[:error] = 'Ошибка сохранения параметра конфигурации сайта'
    end
    redirect_to :action=>'index'
   else
    @item = SiteConfig.new
   end
  end

  def delete
   SiteConfig.find(params[:id]).delete
   redirect_to :action=>'index'
  end
 private
  def protect
   if take_login.nil? or take_login.kind_of?(GuestUser) or (not take_login.can_admin?) then
    redirect_to :controller=>'User', :action=>'login'
    return false
   end
  end

end
