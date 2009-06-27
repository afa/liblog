class SiteController < ApplicationController
#  helper :ToDo
  def initialize
   @submenu = [
    {:text=>'Contacts', :controller=>'Site', :action=>'contacts'},
   ]
  end
  def index
    @title = "Afalone's"
    page = params[:page] || 1
#   @todos = ToDo.paginate :all, :order=>'created_at desc', :page=> 1, :per_page=>10, :conditions=>'parent_id is null'
    @posts = BlogPost.paginate :all, :order=>'created_at desc', :page=>page
  end
  def sitemap
   headers['Content-Type'] = "application/xml"
   @messages = BlogPost.find :all, :limit => 50000, :order => "created_at DESC"
   render :layout => false
  end
  def contacts
    @title = "Как связаться"
  end

end
