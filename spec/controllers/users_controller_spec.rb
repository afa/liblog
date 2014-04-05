#coding: UTF-8
require 'spec_helper'

describe UsersController do

  describe "anonymous user" do
   it "should not can view dashb" do
    get :index
    response.should redirect_to root_path
    flash[:error].should match I18n.t('user.need_login')
   end
  end
  describe "normal user" do
   before(:each) do
    @user = FactoryGirl.create(:user, password: 'password')
    sign_in_as @user
   end
   it "get index should be redirected" do
    get :index
    response.should redirect_to root_path
    flash[:error].should match I18n.t('user.need_login')
   end
  end

  describe "admin user" do
   before(:each) do
    @user = FactoryGirl.create(:user, password: 'password')
    @user.should receive(:is_admin?).and_return(true)
    sign_in_as @user
   end
   it "get index should be ok" do
    get :index
    response.should be_ok
   end
  end

end
