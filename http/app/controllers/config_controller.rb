class ConfigController < ApplicationController
# привилегии config.view, config.edit, config.delete
  before_filter :submenu
  before_filter :protect
  before_filter :protect_admin_access, :only=>[:edit, :add, :destroy]
  before_filter :get_item, :only=>[:show, :edit, :update, :destroy]

  def index
   @items = SiteConfig.all
  end

  def edit
   #@submenu << {:text=>'Удалить', :action=>'delete', :id=>@item.id, :check=>'current_user.logged? and current_user.is_admin?'}
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
    {:text=>'Список', :url=>config_index_path, :check=>'current_user.logged? and current_user.is_admin?'},
    {:text=>'Добавить', :url=>new_config_path, :check=>'current_user.logged? and current_user.is_admin?'}
   ]
  end

  def get_item
   @item = SiteConfig.find params[:id]
  end

  def protect
   unless current_user.logged?
    redirect_to index_path
   end
  end

  def protect_admin_access
    redirect_to :action=>'index' unless current_user.is_admin?
  end

end
