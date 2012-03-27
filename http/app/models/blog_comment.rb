# coding: UTF-8
class BlogComment < ActiveRecord::Base

 validates_associated :post

 belongs_to :user
 belongs_to :post, :foreign_key=>'blog_post_id', :class_name => 'BlogPost', :counter_cache=>:comments_count
 belongs_to :parent, :foreign_key=>:blog_comment_id, :class_name=>'BlogComment'
# has_many :comments, :class_name=>'BlogComment'
 has_many :childs, :foreign_key=>:blog_comment_id, :class_name=>'BlogComment', :order=>'created_at'

 after_save :update_post

 protected
  def update_post
   post=BlogPost.find blog_post_id
   post.update_attributes :comments_count => post.comments.length
  end
end
