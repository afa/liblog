class Author < ActiveRecord::Base
 has_and_belongs_to_many :books

  named_scope :order_by_name, {:order=>'name'}
  named_scope :with_books, {:include=>[:books]}

 def update_books_count
  self.update_attribute :books_count, self.books.length
 end
end
