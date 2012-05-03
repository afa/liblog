require 'test_helper'

class SiteConfigTest < ActiveSupport::TestCase
 context "named test valued test" do
  setup do
   @test = SiteConfig.make :name=>'test', :value=>'test'
  end
  should validate_uniqueness_of :name
  should "test has name test" do
   assert @test.name == 'test'
  end
  should "exist created test accessed by class method[]" do
   assert !SiteConfig['test'].nil?
  end
  should 'exist [test] valued test' do
   assert SiteConfig['test'] == 'test'
  end
  should "exist created test accessed by class method[:symbol]" do
   assert !SiteConfig[:test].nil?
  end
  should 'exist [:test] valued test' do
   assert SiteConfig[:test] == 'test'
  end
 end
end
