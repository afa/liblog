require 'test_helper'

class ToDoControllerTest < ActionController::TestCase
 fixtures :to_dos, :users, :identities
 def test_unlogged_edit_protected
  get :edit, :id=>1
  assert_response :redirect
 end
 def test_logged_edit_access
  session << {:logged=>users(:one_ident).id}
  p session
  get :edit, :id=>1
  assert_response :success
 end
end
