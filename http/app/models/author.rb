class Author < ActiveRecord::Base
 has_and_belongs_to_many :books

  scope :order_by_name, lambda{order 'name'}
  scope :with_books, lambda{includes [:books]}

 def update_books_count
  self.update_attribute :books_count, self.books.length
 end
end
