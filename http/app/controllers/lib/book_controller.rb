class Lib::BookController < ApplicationController
  layout 'lib/application'

  before_filter :load_books, :only=>[:index]
  before_filter :load_book, :only=>[:show, :edit, :update, :destroy]

#  paginate :books, :per_page=>30, :path=>:lib_page_book_index_path

  def index
  end

  def show
  end

  def edit
  end

  def update
   if @book.update_attributes params[:book]
    redirect_to lib_book_index_path
   else
    render :action=>:edit
   end
  end

  def destroy
  end

 protected
  def load_books
#   @books = Book.scoped(:order=>'name')
   @books = Book.with_authors.paginate :order=>'name', :per_page=>100, :page=>params[:page]
  end

  def load_book
   @book = Book.find params[:id]
  end

end
