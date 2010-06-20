require 'test_helper'

class BlogPostTest < ActiveSupport::TestCase
 context 'blog_post' do
  context "with nil raw_type" do
   setup do
    @post = BlogPost.make :raw_type=>nil
   end
   subject {@post}
   should "use SimpleConvertor" do
    assert_equal @post.convertor, SimpleConvertor
   end
  end
  context 'with raw_type Livejournal' do
   setup do
    @post = BlogPost.make :raw_type => 'Livejournal'
   end
   should "use LivejournalConvertor" do
    assert_equal @post.convertor, LivejournalConvertor
   end
  end
 end
 context 'SimpleConvertor' do
  context 'text_to_hash' do
   setup do
    @text = Sham.text
   end
   should 'return hash {:short=>src}' do
    assert SimpleConvertor.text_to_hash(@text) == {:short => @text, :text=>nil, :cut_phrase=>nil}
   end
  end
  context 'hash_to_text' do
   setup do
    @text = Sham.text
    @hash = {:short => @text, :cut_phrase => Sham.text, :text => Sham.text}
   end
   should 'return :short text' do
    assert SimpleConvertor.hash_to_text(@hash) == @text
   end
  end
 end
end
