# coding: UTF-8
class User < ActiveRecord::Base

 include Afauth

 has_many :blog_posts
 scope :order_by_name, order("name")


 validates_uniqueness_of :username, :message=>'Аккаунт с таким именем уже существует', :on=>:create
# validates_presence_of :email, :message=>'Необходимо ввести емайл'
 validates_confirmation_of :password

 attr_accessible :name

  def self.current
   @current
  end

  def self.current=(user)
   @current = user
  end

 def can_admin?
  self.is_admin?
 end

 def can_post?
  self.is_blogger?
 end

 def can_login?
  not self.is_banned?
 end

 def logged?
  self.new_record? ? false : true 
 end

 def self.register_email_user(email)
  self.find_or_create_by_email :username=>email, :email=>email
 end
end

