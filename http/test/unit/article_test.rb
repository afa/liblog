require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
 context "article" do 
  setup do
   @article = Article.make
  end
  subject { @article }
  should validate_uniqueness_of :name
 end
end
