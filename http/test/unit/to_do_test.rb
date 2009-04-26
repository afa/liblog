require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
  fixtures 'to_dos'
  def setup

  end
  def test_percent_done_tree_50
   assert_in_delta to_dos(:tree_root).percent_done, 50, 0.01, 'percent_done for 50% calc wrongly'
  end
  def test_percent_done_100
   assert_in_delta to_dos(:tree_item).percent_done, 100, 0.01, 'percent_done for 100% calc wrongly'
  end
  def test_percent_done_0
   assert_in_delta to_dos(:normal).percent_done, 0, 0.01, 'percent_done for 0% calc wrongly'
  end
  def test_percent_done_0_for_nil
   assert_in_delta to_dos(:nil_done).percent_done, 0, 0.01, 'percent_done for done == nil 0% calc wrongly'
  end
end
