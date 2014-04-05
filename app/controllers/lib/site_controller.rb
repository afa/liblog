# coding: UTF-8
class Lib::SiteController < ApplicationController
  layout 'lib/application'
  def index
   @books_count = Book.count
   @authors_count = Author.count
  end

  def rss
   @books = Book.lasts.only_50.with_authors
   render :layout=>false
  end

end
