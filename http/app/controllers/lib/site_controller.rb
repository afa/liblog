class Lib::SiteController < ApplicationController
  layout 'lib/application'
  def index
   @books_count = Book.count
   @authors_count = Author.count
  end

end
