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
   @authors = Author.order_by_name.paginate :per_page=>100, :page=>params[:page]
  end

  def get_author
   @author = Author.with_books.find params[:id]
  end

end
