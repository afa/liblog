class Book < ActiveRecord::Base
 has_and_belongs_to_many :authors
 has_and_belongs_to_many :genres
 belongs_to :lang, :counter_cache=>true
 belongs_to :bundle, :counter_cache=>true

 after_save :update_count

 named_scope :unbundled, lambda { {:conditions=>'bundle_id is null'} }

 def Book.per_page
  30
 end

 private
  def update_count
   self.authors.each{|a| a.update_books_count}
  end
 
end
