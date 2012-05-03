# coding: UTF-8
class GuestUser < User
#Класс-затычка. Ничего не умеет, нет ролей и привилегий.
 def initialize
  super
  self.username = ''
  self.password = ''
 end
 def has_role? (role_name)
  false
 end
 def has_privilege? (priv_name)
  false
 end
 def can_admin?
  false
 end
 def can_post?
  false
 end
 def can_login?
  false
 end
 def logged?
  false
 end
end
