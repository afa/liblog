require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
 context "non done todo" do
  setup do
   @todo_active = ToDo.make :done => false
  end
  should "return 0 percent done" do
   assert_in_delta @todo_active.percent_done, 0, 1
  end
  context "non done with done child" do
   setup do
    @parent = ToDo.make(:done=>true)
    @todo_tree = ToDo.make :parent => @parent, :done => false
   end
   should "return 50 percent done" do
    assert_in_delta @parent.percent_done, 50, 1
   end
  end
  context "done todo" do
   setup do
    @todo_done = ToDo.make :done => true
   end
   should "return 100 percents done" do
    assert_in_delta @todo_done.percent_done, 100, 1
   end
  end
 end


end
