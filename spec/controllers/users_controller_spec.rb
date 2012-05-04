#coding: UTF-8
require 'spec_helper'

describe UsersController do

  describe "anonymous user" do
   it "should be redirected to login" do
    get :index
    #p response.methods
    #response.should redirect_url_match /\/users\/login/
    flash[:error].should =~ /be logged in/
   end
  end
  it "should get login" do
   get :login
   response.should render_template 'login'
  end
  describe "normal user" do
   before(:each) do
    @user = FactoryGirl.create(:user)
   end
  end

end
