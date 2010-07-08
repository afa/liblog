class User < ActiveRecord::Base
 belongs_to :identity

 acts_as_authorized_user
 acts_as_authorizable

 validates_uniqueness_of :username, :message=>'Аккаунт с таким именем уже существует', :on=>:create
# validates_presence_of :email, :message=>'Необходимо ввести емайл'
 validates_confirmation_of :password

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
  ident = Identity.find_by_name "mailer identity"
  self.find_or_create_by_email :username=>email, :email=>email
 end
end

