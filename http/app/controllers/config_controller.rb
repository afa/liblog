class ConfigController < ApplicationController
# привилегии config.view, config.edit, config.delete
  before_filter :submenu
  before_filter :protect
  before_filter :protect_edit, :only=>[:edit, :add]
  before_filter :protect_delete, :only=>[:destroy]
  before_filter :get_item, :only=>[:show, :edit, :update, :destroy]

  def index
   @items = SiteConfig.all
  end

  def edit
   #@submenu << {:text=>'Удалить', :action=>'delete', :id=>@item.id, :check=>'take_login.logged? and take_login.is_admin?'}
  end

  def update
   if @item.update_attributes params[:site_config]
    flash[:notice] = "Параметр конфигурации сайта #{@item.name} сохранен"
    redirect_to config_index_path
   else
    flash[:error] = "Ошибка сохранения параметра конфигурации #{@item.name}"
    render :action=>'edit'
   end
   
  end

  def new
   @item = SiteConfig.new
  end

  def create
   if SiteConfig.create params[:site_config]
    flash[:notice] = 'Параметр конфигурации сайта сохранен'
    redirect_to config_index_path
   else
    flash[:error] = 'Ошибка сохранения параметра конфигурации сайта'
    render :action=>:new
   end
  end

  def destroy
   @item.destroy
   redirect_to config_index_path
  end

 protected

  def submenu
   @submenu = [
    {:text=>'Список', :url=>config_index_path, :check=>'take_login.logged? and take_login.is_admin?'},
    {:text=>'Добавить', :url=>new_config_path, :check=>'take_login.logged? and take_login.is_admin?'}
   ]
  end

  def get_item
   @item = SiteConfig.find params[:id]
  end

  def protect
   unless take_login.logged? and take_login.is_admin?
    redirect_to index_path
   end
  end

  def protect_edit
    redirect_to :action=>'index' unless take_login.logged? and  take_login.is_admin?
  end

  def protect_delete
    redirect_to :action=>'index' unless take_login.logged? and take_login.is_admin?
  end

end
