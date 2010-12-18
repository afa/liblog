require 'spec_helper'

describe Lib::BookController do
 before(:each) do
  @book=Book.create :name=>'aa', :state=>'published'
 end
 it "should get index" do
  get :index
  assigns(:books).should_not be_empty
 end
end
