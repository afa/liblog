# coding: UTF-8
class Genre < ActiveRecord::Base
 has_and_belongs_to_many :books

  def join(genre)
   (genre.books - self.books).each do |book|
    self.books << book
    book.save
   end
   self.save
  end

  def update_books_count
   self.update_attribute :books_count, self.book_ids.length
  end
end
