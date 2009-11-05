class Lib::SiteController < ApplicationController
  layout 'lib/application'
  def index
   @books_count = Book.count
   @authors_count = Author.count
  end

  def rss
   @books = Book.find(:all, :limit=>50, :order=>'created_at DESC')
   render :layout=>false
  end

end
