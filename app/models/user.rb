# coding: UTF-8
class User < ActiveRecord::Base
include Clearance::User


 #include Afauth::Model
 #authen_field_name :username
 

 has_many :blog_posts, class_name: Blog::Post
 scope :order_by_name, -> { order("name") }


 validates_uniqueness_of :username, :message=>'Аккаунт с таким именем уже существует'
# validates_presence_of :email, :message=>'Необходимо ввести емайл'
# validates_confirmation_of :password

 #attr_accessible :name

#  def self.current
#   @current
#  end

#  def self.current=(user)
#   @current = user
#  end

 def can_admin?
  self.is_admin?
 end

 def is_admin?
  self.username == 'afa'
 end

 def is_banned?
  false
 end

 def is_blogger?
  true
 end

 def can_post?
  self.is_blogger?
 end

 def can_login?
  not self.is_banned?
 end

# def logged?
#  self.new_record? ? false : true 
# end

 def self.register_email_user(email)
  self.find_or_create_by_email :username=>email, :email=>email
 end
end

