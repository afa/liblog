class Lib::AuthorController < ApplicationController
  layout 'lib/application'
  before_filter :get_authors
  before_filter :get_author, :only=>[:show]

#  paginate :authors, :per_page=>30, :path=>:lib_page_author_index_path

  def index
  end

  def show
  end

 protected
  def get_authors
#   @authors = Author.order_by_name
   @authors = Author.paginate :order=>'last_name, first_name', :per_page=>100, :page=>params[:page]
  end

  def get_author
   @author = Author.find params[:id], :include=>[:books]
  end

end
