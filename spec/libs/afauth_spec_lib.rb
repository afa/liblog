#coding: UTF-8
require 'spec_helper'

shared_examples "afauth_model" do |auth_class|
 before do
  @model = FactoryGirl.create(auth_class.name.downcase.to_sym)
 end
 it "should be #{auth_class.name}" do
  @model.should be_is_a(auth_class)
 end

 context "when current blank" do
  context "when not allowed unlogged" do
   it "should raise AuthError"
  end
  context "when allowed unlogged" do
   it "but what it should?"
  end
 end

 context "when current valid" do
  it "should return current auth"
 end
end
