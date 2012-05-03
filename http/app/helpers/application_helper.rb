# coding: UTF-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 def lib_menu
  [
   { :text => 'lib', :url=>lib_root_path}
  ]
 end

end
