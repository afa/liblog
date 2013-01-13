#coding: UTF-8
require 'spec_helper'
require 'lib/afauth_spec'

describe User do
 before do
  @user = FactoryGirl.create(:user)
 end
 include_examples 'afauth', User
end
