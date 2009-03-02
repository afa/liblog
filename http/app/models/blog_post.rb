class BlogPost < ActiveRecord::Base
 belongs_to :identity
 has_many :blog_comments
 
end
