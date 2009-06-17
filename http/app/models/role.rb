class Role < ActiveRecord::Base
 has_many :role_maps, :source=>:RoleMap
 has_many :users, :through=>:role_maps
 has_many :privilege_maps, :source=>:PrivilegeMap
 has_many :privileges, :through=>:privilege_maps

 def has_privilege?(priv_name)
  Privilege.find( :all, :from=>'privileges "p", privilege_maps "pm"', :conditions=>[ 'p.name = :priv and p.id = pm.privilege_id and pm.role_id = :uid', { :priv=>priv_name, :uid=>self.id } ] ).size > 0 ? true : false
 end
end
