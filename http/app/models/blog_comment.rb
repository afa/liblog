class BlogComment < ActiveRecord::Base
 belongs_to :blog_post
 belongs_to :parent, :foreign_key=>:blog_comment_id
 has_many :blog_comments, :source=>:blog_comment
end
