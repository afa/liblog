require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
 fixtures :identities, :users
 def test_none_users
  assert identities(:none_users).users.empty?
 end

end
