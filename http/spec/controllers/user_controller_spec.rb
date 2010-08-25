require 'spec_helper'

describe UserController do

  describe "anonymous user" do
   it "should be redirected to login" do
    #get :index, :subdomains=>['', 'www'], :host=>'e3pc'
    get :index, :subdomains=>[''], :host=>'e3pc'
    #p response.methods
    #response.should redirect_url_match /\/users\/login/
    flash[:error].should =~ /be logged in/
   end
  end
  it "should get login" do
   get :login, :subdomains=>[''], :host=>'e3pc'
   response.should render_template 'login'
  end
  describe "normal user" do
   before(:each) do
    @user = Factory.create(:user)
   end
   it "should not has any roles" do
    @user.roles.should be_empty
   end
  end

end
