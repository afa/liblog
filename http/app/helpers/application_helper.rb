# coding: UTF-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 attr_accessor :current_user
 def current_user
  if @logged.nil? then
   unless session[:logon].nil? then
    @logged = User.find( :first, session[:logon] ) or GuestUser.new
   else
    @logged = GuestUser.new
   end
  end
  @logged
 end

 def lib_menu
  [
   { :text => 'lib', :url=>lib_root_path}
  ]
 end

 def menu_bar(menu = [])
  menu.collect  do | item |
   if (item.has_key? :check and eval(item[:check])) or not item.has_key? :check
    item.delete :check 
    if item.has_key? :type then 
     send("#{item.delete(:type)}_to", item.delete(:text), item)
    else
     if item.has_key? :url
      link_to_unless_current( item.delete(:text), item.delete(:url))
     else
      link_to_unless_current( item.delete(:text), item)
     end
    end
   end
  end.compact.join('&nbsp;').html_safe
 end

 def main_menu
  [
   { :text=>'Home', :url=>root_path },
   { :text=>'Users', :url=>users_path, :check=>'current_user.can_admin?' },
   { :text=>'Blog', :url=>blogs_path },
   { :text=>'Stories', :url=>articles_path },
   { :text=>'Config', :controller=>'Config', :url=>config_index_path, :check=>"current_user.is_admin?" },
 #  { :text=>'ToDo', :controller=>'ToDo', :action=>'index', :check=>"current_user.has_privilege? 'todo.view'" },
 #  { :text=>'Stats', :controller=>'Stats', :action=>'index', :check=>"current_user" },
   { :text=>'Lib', :url=>lib_root_path }
  ]
 end
end
