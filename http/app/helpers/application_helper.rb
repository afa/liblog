# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 attr_accessor :take_login
 def take_login
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
   []
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
  end.compact.join('&nbsp;')
 end
 def main_menu
  [
   { :text=>'Home', :controller=>"Site", :action=>"index" },
   { :text=>'Users', :controller=>"User", :action=>"index", :check=>'take_login.can_admin?' },
   { :text=>'Blog', :controller=>'Blog', :action=>'index' },
   { :text=>'Config', :controller=>'Config', :action=>'index', :check=>"take_login.has_privilege? 'config.view'" },
   { :text=>'ToDo', :controller=>'ToDo', :action=>'index', :check=>"take_login.has_privilege? 'todo.view'" },
   { :text=>'Stats', :controller=>'Stats', :action=>'index', :check=>"take_login" },
   { :text=>'Lib', :url=>lib_index_path }
  ]
 end
end
