class Lib::BookController < ApplicationController
  layout 'lib/application'

  before_filter :load_books
  before_filter :load_book, :only=>[:show]

#  paginate :books, :per_page=>30, :path=>:lib_page_book_index_path

  def index
  end

  def show
  end

 protected
  def load_books
#   @books = Book.scoped(:order=>'name')
   @books = Book.paginate :order=>'name', :per_page=>100, :page=>params[:page]
  end

  def load_book
   @book = Book.find params[:id]
  end

end
