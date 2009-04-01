class BlogPost < ActiveRecord::Base
 cattr_reader :per_page
 @@per_page = 40
 belongs_to :identity
 has_many :blog_comments
 
end
