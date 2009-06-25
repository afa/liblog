class SiteController < ApplicationController
#  helper :ToDo
  def index
    @title = "Afalone's s'up"
    page = params[:page] || 1
#   @todos = ToDo.paginate :all, :order=>'created_at desc', :page=> 1, :per_page=>10, :conditions=>'parent_id is null'
    @posts = BlogPost.paginate :all, :order=>'created_at desc', :page=>page
  end

end
