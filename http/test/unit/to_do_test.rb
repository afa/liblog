require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures 'to_dos'
  def setup

  end
  def test_percent_done_tree_50
   assert_in_delta @tree_root.percent_done, 50, 1, 'percent_done for 50% calc wrongly'
  end
  def test_percent_done_100
   assert_in_delta @tree_item.percent_done, 100, 0.01, 'percent_done for 100% calc wrongly'
  end
  def test_percent_done_0
   assert_in_delta @normal.percent_done, 0, 0.01, 'percent_done for 0% calc wrongly'
  end
  def test_percent_done_0_for_nil
   assert_in_delta @nil_done.percent_done, 0, 0.01, 'percent_done for done == nil 0% calc wrongly'
  end
end
