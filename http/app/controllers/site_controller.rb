class SiteController < ApplicationController
  helper :ToDo
  def index
   @title = "Afalone's s'up"
   @todos = ToDo.paginate :all, :order=>'created_at desc', :page=> 1, :per_page=>10, :conditions=>'parent_id is null'
  end

end
