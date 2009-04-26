require 'test_helper'

class UserControllerTest < ActionController::TestCase
  fixtures :identities, :users
  def test_can_view_index_not_logged
   get :index
   assert :success
  end
end
