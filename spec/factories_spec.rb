#coding: UTF-8
require 'spec_helper'

describe 'validate FactoryGirl factories' do
  #FactoryGirl.factories.select{|f| f.name != :user }.each do |factory|
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      subject { FactoryGirl.build(factory.name) }

      it "is valid" do
        subject.valid?
        p subject.errors.full_messages
        expect(subject.valid?).to be
        subject.errors.full_messages.should be_empty
      end
    end
  end
end

