class BlogPost < ActiveRecord::Base
 has_one :imported_entry
 cattr_reader :per_page
 @@per_page = 40
 belongs_to :identity
 has_many :blog_comments
 def permalink
  self.name
 end 
end
