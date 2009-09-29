class Lang < ActiveRecord::Base
 has_many :books

  def join(lang)
   (lang.books - self.books).each do |book|
    self.books << book
    book.save
   end
   self.save
  end

end
