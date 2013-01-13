#coding: UTF-8
require 'spec_helper'

describe BlogsController do
 describe "GET new" do
  before do
   @user = FactoryGirl.create :user
   @user.stub!(:is_blogger?).and_return(true)
   User.current = @user
   get :new
  end
  it "should be success" do
   response.should be_success
  end
 end

 describe "GET index" do
  before do
   @posts = FactoryGirl.create_list(:blog_post, 30)
   get :index
  end
  it "should be success" do
   response.should be_success
  end
  it "should assign posts" do
   assigns[:posts].should_not be_empty
  end
  it "should paginate posts"
  #TODO:add tags
 end

 describe "GET rss" do
  before do
   get :rss, :format => :xml
  end
  it "should be success" do
   response.should be_success
  end
  it "should assign posts" do
   assigns[:posts].should_not be_nil
  end
 end

 describe "GET edit" do
  before do
   @user = FactoryGirl.create :user
   @post = FactoryGirl.create :blog_post
   @user.stub!(:is_admin?).and_return(true)
   controller.current_user = @user
   get :edit, :id => @post.id
  end
  it "should be success" do
   response.should be_success
  end
  it "should assign post" do
   assigns[:post].should == @post
  end
 end

 describe "GET show" do
  before do
   @post = FactoryGirl.create :blog_post
   get :show, :id => @post.id
  end
  it "should be success" do
   response.should be_success
  end
  it "should assign post" do
   assigns[:post].should == @post
  end
 end

 describe "POST create" do
  before do
   @user = FactoryGirl.create :user
   @user.stub!(:is_blogger?).and_return(true)
   controller.current_user = @user
   post :create
  end
  it "should be redirect" do
   response.should be_redirect
  end
 end

 describe "PUT update" do
  before do
   @user = FactoryGirl.create :user
   @post = FactoryGirl.create :blog_post
   @user.stub!(:is_admin?).and_return(true)
   controller.current_user = @user
   put :update, :id => @post.id
  end
  it "should be redirect" do
   response.should be_redirect
  end
  it "should assign post" #really?
 end

 describe "DELETE destroy" do
  before do
   @user = FactoryGirl.create :user
   @post = FactoryGirl.create :blog_post
   @user.stub!(:is_admin?).and_return(true)
   controller.current_user = @user
   delete :destroy, :id => @post.id
  end
  it "should be redirect" do
   response.should be_redirect
  end
 end

 describe "GET new" do
  before do
   get :new
  end
  it "should be redirected" do
   response.should be_redirect
  end
  it "should flash" do
   flash[:error].should_not be_blank
  end
 end
end
