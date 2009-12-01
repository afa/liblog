# The table that links roles with users (generally named RoleUser.rb)
class RolesUser < ActiveRecord::Base
  set_primary_key :created_at
  belongs_to :user
  belongs_to :role
end
