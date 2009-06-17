require 'test_helper'
# test protected, get _no_ access, put access, get show, expired/normal/now
class ToDoControllerTest < ActionController::TestCase
 self.use_instantiated_fixtures = true
 fixtures :to_dos, :identities, :users
# protected test
 def test_unlogged_delete_protected
  get :delete, :id=>@normal.id
  assert_response :redirect
 end
 def test_unlogged_edit_protected
  get :edit, :id=>@normal.id
  assert_response :redirect
 end
 def test_unlogged_add_protected
  get :add, {:id=>nil}
  assert_response :redirect
 end
 def test_unlogged_add_child_protected
  get :add, {:id=>@normal.id}
  assert_response :redirect
 end
# logged get test (no access)
 def test_logged_edit_access
  get :edit, {:id=>@normal.id}, {'logon'=>@one_ident.id}
  assert_response :success
 end
 def test_logged_delete_get_access
  assert_no_difference 'ToDo.count' do 
   get :delete, {:id=>@normal.id}, {'logon'=>@one_ident.id}
  end
  assert_equal nil, flash[:notice] 
  assert_response :redirect
  assert_redirected_to :controller=>'ToDo', :action=>'index'
 end
 def test_logged_add_get_access
  get :add, {:id=>nil}, {'logon'=>@one_ident.id}
  assert_response :success
 end
 def test_logged_add_child_get_access
  get :add, {:id=>@normal.id}, {'logon'=>@one_ident.id}
  assert_response :success
 end
# test put access
 def test_logged_delete_post_access
  assert_difference 'ToDo.count', -1 do 
   post :delete, {:id=>@normal.id}, {'logon'=>@one_ident.id}
  end
  assert_equal "Хотелка успешно удалена", flash[:notice] 
  assert_response :redirect
  assert_redirected_to :controller=>'ToDo', :action=>'index'
 end
# test show
 def test_index
  get :index
  assert_response :success
 end
 def test_show
  get :show, {:id=>@normal.id}
  assert_response :success
 end
 def test_show_normal
  get :show, {:id=>@normal.id}
  assert_select "div.to_do > div.not_expired"
 end
 def test_show_expired
  get :show, {:id=>@expired.id}
  assert_select "div.to_do > div.expired"
 end
 def test_show_expire_now
  get :show, {:id=>@expire_now.id}
  assert_select "div.to_do div.expire_today"
 end
end
