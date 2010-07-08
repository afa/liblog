require 'test_helper'

class UserControllerTest < ActionController::TestCase
 context "users get" do
  setup do
   #@user = User.make
   get :login, {:subdomains=>['', 'www'], :host=>'e3pc'}, {:subdomain=>nil}
#
  end
#  should respond_with :success
  should "sucessful get login" do
   assert_response :success
#   p user_index_url(:subdomains=>'www', :host=>'e3pc')
#   assert_recognizes_with_host user_index_url(:subdomains=>'www'), {:path=>"/user", :host=>'e3pc'}
  end
 end
 should "route to index" do
  assert_generates_with_host( '/user', {:controller=>'user', :action=>'index', :subdomains=>['', "www"]}, 'e3pc')
 end
end
