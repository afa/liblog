#coding: UTF-8
require 'spec_helper'
#require 'lib/afauth_spec_lib'

describe User do
 before do
  @user = FactoryGirl.create(:user)
 end
 subject {@user}

 it { should be_valid }

 #include_examples 'afauth_model', User
end
