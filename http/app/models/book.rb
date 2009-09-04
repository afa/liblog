class Book < ActiveRecord::Base
 has_and_belongs_to_many :authors
 has_and_belongs_to_many :genres
 belongs_to :lang
 belongs_to :bundle

 def Book.per_page
  30
 end
end
