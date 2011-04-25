class SiteController < ApplicationController
#  helper :ToDo
 before_filter :submenu, :only=>[:index, :contacts]

  def index
    @title = "Afalone's"
    page = params[:page] || 1
#   @todos = ToDo.paginate :all, :order=>'created_at desc', :page=> 1, :per_page=>10, :conditions=>'parent_id is null'
    @posts = BlogPost.lasts.paginate :page=>page
  end

  def sitemap
   headers['Content-Type'] = "application/xml"
   @messages = BlogPost.lasts.limit(5000).all
   render :layout => false
  end

  def contacts
    @title = "Как связаться"
  end

 protected

  def submenu
   @submenu = [{:text=>'Contacts', :url=>contacts_url}] 
  end

end
