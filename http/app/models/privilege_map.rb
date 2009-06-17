class PrivilegeMap < ActiveRecord::Base
 belongs_to :privilege
 belongs_to :role
end
