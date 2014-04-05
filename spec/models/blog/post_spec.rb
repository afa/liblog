require 'spec_helper'

describe Blog::Post do
  context "auth for" do
    before do
      @user = FactoryGirl.create :user
    end
  end
end
