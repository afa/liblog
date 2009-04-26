# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 attr_accessor :take_login
 def use_tinymce
  @content_for_tinymce = "" 
  content_for :tinymce do
   javascript_include_tag "tiny_mce/tiny_mce"
  end
  @content_for_tinymce_init = "" 
  content_for :tinymce_init do
   javascript_include_tag "mce_editor"
  end
 end
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
end
