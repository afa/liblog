class User < ActiveRecord::Base
# attr_reader :can_admin?, :can_post?, :can_login?
 belongs_to :identity
 has_many :role_maps, :source=>:RoleMap
 has_many :roles, :through=>:role_maps
#, :source=>'Role'
 validates_uniqueness_of :username, :message=>'Аккаунт с таким именем уже существует', :on=>:create
 def can_admin?
  has_role?('admin')
 end
 def can_post?
  has_role?('post')
 end
 def can_login?
  has_role?('login')
 end
 def has_role? ( role_name )
  Role.find(:all, :from=>'roles "r", role_maps "rm" ', :conditions=>[ 'r.id = rm.role_id and rm.user_id = :uid and r.name=:role', {:uid=>self.id, :role=>role_name} ] ).size > 0 ? true : false
 end
 def has_privilege? ( priv_name )
  Privilege.find( :all, :from=>'privileges "p", privilege_maps "pm", role_maps "rm"', :conditions=>[ 'p.name = :priv and rm.role_id = pm.role_id and p.id = pm.privilege_id and rm.user_id = :uid', { :priv=>priv_name, :uid=>self.id } ] )
 end
 def logged?
  self.new_record? ? false : true 
 end
end

