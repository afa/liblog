require 'test_helper'
require 'fakefs'

class BookTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
 def test_fs
  Dir.mkdir "directory"
  assert File.directory?("directory")
 end
end



