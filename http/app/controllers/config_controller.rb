class ConfigController < ApplicationController
# привилегии config.view, config.edit, config.delete
  before_filter :submenu
  before_filter :protect
  before_filter :protect_edit, :only=>[:edit, :add]
  before_filter :protect_delete, :only=>[:delete]
  def submenu
   @submenu = [
    {:text=>'Список', :action=>'index', :check=>'take_login.logged? and take_login.has_privilege?("config.view")'},
    {:text=>'Добавить', :action=>'add', :check=>'take_login.logged? and take_login.has_privilege?("config.edit")'}
   ]
  end

  protected :submenu

  def index
   @items = SiteConfig.find :all
  end

  def edit
   @item = SiteConfig.find params[:id]
   @submenu << {:text=>'Удалить', :action=>'delete', :id=>@item.id, :check=>'take_login.logged? and take_login.has_privilege?("config.delete")'}
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
   SiteConfig.find(params[:id]).destroy
   redirect_to :action=>'index'
  end
 private
  def protect
   unless take_login.logged? and take_login.has_privilege?("config.view")
    redirect_to index_path
   end
  end
  def protect_edit
    redirect_to :action=>'index' unless take_login.logged? and  take_login.has_privilege?("config.edit")
  end
  def protect_delete
    redirect_to :action=>'index' unless take_login.logged? and take_login.has_privilege?("config.delete")
  end

end
