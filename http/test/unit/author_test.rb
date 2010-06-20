require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
 context "author" do
  setup do
   @author = Author.make
  end
 end
end
